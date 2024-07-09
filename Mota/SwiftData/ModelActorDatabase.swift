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
    func insert(_ model: WorkoutNew) async {
        modelContext.insert(model)
    }
    
    func delete() async throws {
        try modelContext.delete(model: WorkoutNew.self)
    }
    
    func fetch(_ descriptor: FetchDescriptor<WorkoutNew>) async throws -> [WorkoutNew] {
        return try modelContext.fetch(descriptor)
    }
    
    func save() async throws {
        try modelContext.save()
    }
    
    
}
