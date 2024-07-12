//
//  ModelActorDatabase.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftData

@ModelActor
actor ModelActorDatabase: Database {
    func insert(_ model: some PersistentModel) async {
        modelContext.insert(model)
    }
    
    func delete<T: PersistentModel>(_ model: T) async {
        modelContext.delete(model)
    }
    
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) async throws -> [T] {
        return try modelContext.fetch(descriptor)
    }
    
    func save() async throws {
        try modelContext.save()
    }
    
    func fetchCount<T: PersistentModel>( fetchDescriptor: FetchDescriptor<T>) async throws -> Int {
        return try modelContext.fetchCount(fetchDescriptor)
    }
    
}
