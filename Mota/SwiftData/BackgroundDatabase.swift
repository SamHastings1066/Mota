//
//  BackgroundDatabase.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftData

final class BackgroundDatabase: Database {
    
    private actor DatabaseContainer {
        private let factory: @Sendable () -> any Database
        private var wrappedTask: Task<any Database, Never>?
        
        init(factory: @escaping @Sendable () -> any Database) {
            self.factory = factory
        }
        
        fileprivate var database: any Database {
            get async {
                if let wrappedTask {
                    return await wrappedTask.value
                }
                let task = Task { factory () }
                wrappedTask = task
                return await task.value
            }
        }
    }
    
    private let container: DatabaseContainer
    
    private var database: any Database {
        get async {
            await container.database
        }
    }
    
    internal init(_ factory: @escaping @Sendable () -> any Database) {
        container = DatabaseContainer(factory: factory)
    }
    
    convenience init(modelContainer: ModelContainer) {
        self.init {
            return ModelActorDatabase(modelContainer: modelContainer)
        }
    }
    
    
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) async throws -> [T] {
        try await container.database.fetch(descriptor)
    }
    
    func save() async throws {
        try await container.database.save()
    }
    
    func delete<T: PersistentModel>(_ model: T) async {
        await container.database.delete(model)
    }
    
    func insert(_ model: some PersistentModel) async {
        return await container.database.insert(model)
    }
    
    func fetchCount<T: PersistentModel>( fetchDescriptor: FetchDescriptor<T>) async throws -> Int {
        return try await container.database.fetchCount(fetchDescriptor: fetchDescriptor)
    }
    
    func update<T: PersistentModel>(_ model: T, with changes: (inout T) -> Void) async throws {
        try await container.database.update(model) { model in
            changes(&model)
        }
    }
        
}
