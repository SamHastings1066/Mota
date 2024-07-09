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
    
    
    func fetch(_ descriptor: FetchDescriptor<WorkoutNew>) async throws -> [WorkoutNew] {
        try await container.database.fetch(descriptor)
    }
    
    func save() async throws {
        try await container.database.save()
    }
    
    func delete() async throws {
        try await container.database.delete()
    }
    
    func insert(_ model: WorkoutNew) async {
        return await container.database.insert(model)
    }
        
}
