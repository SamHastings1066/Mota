//
//  SharedDatabase.swift
//  Mota
//
//  Created by sam hastings on 09/07/2024.
//

import Foundation
import SwiftData

struct SharedDatabase {
    static let shared = SharedDatabase()
    static let preview = SharedDatabase(inMemory: true)
    
    let modelContainer: ModelContainer
    let database: any Database
    
    private init(inMemory: Bool = false,
        modelContainer: ModelContainer? = nil,
        database: (any Database)? = nil) {
        let schema = Schema([WorkoutNew.self, DatabaseExercise.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
            // TODO: remove forced unwrap
            let container = try! ModelContainer(for: schema, configurations: config)
            let modelContainer = modelContainer ?? container
        self.modelContainer = modelContainer
        self.database = database ?? BackgroundDatabase(modelContainer: modelContainer)        
    }
    
    func loadExercises() async {
        do {
            let descriptor = FetchDescriptor<DatabaseExercise>()
            let existingExercises = try await database.fetchCount(fetchDescriptor: descriptor)
            guard existingExercises == 0 else {
                return
            }
            guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
                fatalError("Failed to find exercises.json")
            }
            let data = try Data(contentsOf: url)
            let exercises = try JSONDecoder().decode([DatabaseExercise].self, from: data)
            for exercise in exercises {
                await database.insert(exercise)
            }
            print("Exercises created")
        } catch {
            print("Exercises could not be loaded")
        }
    }
}
