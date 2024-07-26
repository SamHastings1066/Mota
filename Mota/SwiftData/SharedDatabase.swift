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

// Xcode Preview methods
extension SharedDatabase {
    func loadDummyWorkout() async -> WorkoutNew? {
        do {
            let descriptor = FetchDescriptor<DatabaseExercise>(
                predicate: #Predicate {
                    $0.id.localizedStandardContains("Barbell_Squat") ||
                    $0.id.localizedStandardContains("Barbell_Deadlift") ||
                    $0.id.localizedStandardContains("Barbell_Bench_Press_-_Medium_Grip") ||
                    $0.id.localizedStandardContains("Seated_Cable_Rows")
                }, sortBy: [ SortDescriptor(\.name, order: .forward)]
            )
            let exercises = try await database.fetch(descriptor)
            let fullBodyWorkout = WorkoutNew(name: "Full body",
                                             supersets: [
                                                SupersetNew(
                                                    rounds: [
                                                        Round(singlesets: [SinglesetNew(exercise: exercises[0], weight: 100, reps: 10), SinglesetNew(exercise: exercises[1], weight: 90, reps: 15)], rest: 60),
                                                        Round(singlesets: [SinglesetNew(exercise: exercises[0], weight: 100, reps: 10), SinglesetNew(exercise: exercises[1], weight: 90, reps: 15)], rest: 60)
                                                    ]
                                                ),
                                                SupersetNew(
                                                    rounds: [
                                                        Round(singlesets: [SinglesetNew(exercise: exercises[3], weight: 10, reps: 20)], rest: 60),
                                                    ]
                                                )
                                             ]
            )
            
            await database.insert(fullBodyWorkout)
            try? await database.save()
            
            print("Dummy workout created")
            return fullBodyWorkout
        } catch {
            print("Dummy workout could not be created")
            return nil
        }
    }
    
}
