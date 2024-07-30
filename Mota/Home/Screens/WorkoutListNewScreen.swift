//
//  WorkoutListNewScreen.swift
//  Mota
//
//  Created by sam hastings on 15/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutListNewScreen: View {
    
    @State private var workouts: [WorkoutTemplate] = []
    @State private var sampleBackgroundExercises: [DatabaseExercise] = []
    @Environment(\.database) private var database
    @State private var path = [WorkoutTemplate]()
    @State private var shouldRenameWorkout = false
    
    
    private func createExampleWorkouts() async -> [WorkoutTemplate] {
        let startCreatingModels = Date()
        var rounds = [Round]()
        for _ in 0..<2000 {
            let round = Round(singlesets: [SinglesetNew(exercise: sampleBackgroundExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleBackgroundExercises[1], weight: 90, reps: 15)])
            rounds.append(round)
        }
        let workout1 = WorkoutTemplate(
            name: "Legs workout",
            supersets: [
                SupersetNew(
                    rounds: rounds
                )
            ]
        )
        
        let workout2 = WorkoutTemplate(name: "Arms workout",
                                  supersets: [
                                    SupersetNew(
                                        rounds: [
                                            Round(singlesets: [SinglesetNew(exercise: sampleBackgroundExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleBackgroundExercises[1], weight: 90, reps: 15)])
                                        ]
                                    ),
                                    SupersetNew(
                                        rounds: [
                                            Round(singlesets: [SinglesetNew(exercise: sampleBackgroundExercises[2], weight: 10, reps: 20)]),
                                        ]
                                    )
                                  ]
        )
        print("Time to create models: \(Date().timeIntervalSince(startCreatingModels))")
        
        return [workout1, workout2]
    }
    
    private func addExampleWorkouts() {
        Task {
            let exampleWorkouts = await createExampleWorkouts()
            
            
            let startInsertingModels = Date()
            for workout in exampleWorkouts {
                await database.insert(workout)
            }
            workouts.append(contentsOf: exampleWorkouts)
            print("Time to insert models: \(Date().timeIntervalSince(startInsertingModels))")
            try? await database.save()
            
        }
    }
    
    private func removeWorkout(_ offsets: IndexSet) {
        Task {
            let startDeletingModels = Date()
            for offset in offsets {
                let workout = workouts[offset]
                await database.delete(workout) // causes error
                workouts.remove(at: offset)
            }
            print("Time to Delete models: \(Date().timeIntervalSince(startDeletingModels))")
            try? await database.save()
        }
    }
    
    func addNewWorkout() {
        Task {
            let newWorkout = WorkoutTemplate()
            await database.insert(newWorkout)
            try await database.save()
            path = [newWorkout]
            workouts.append(newWorkout)
            shouldRenameWorkout = true
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(value: workout) {
                        Text(workout.name)
                            .font(.headline)
                    }
                }
                .onDelete(perform: removeWorkout)
            }
            .navigationTitle("Workout List")
            .navigationDestination(for: WorkoutTemplate.self) { workout in
                WorkoutNewScreen(renameWorkout: $shouldRenameWorkout, workoutID: workout.id)
            }
            .toolbar {
                Button("Add Samples", action: addExampleWorkouts)
                Button("Add workout", systemImage: "plus", action: addNewWorkout)
            }
        }
        .task {
            do {
                let descriptor = FetchDescriptor<WorkoutTemplate>()
                workouts = try await database.fetch(descriptor)
                sampleBackgroundExercises = try await database.fetch(FetchDescriptor<DatabaseExercise>())
            } catch {
                
            }
        }
    }
}

#Preview {
    
    return AsyncPreviewView(
        asyncTasks: {
            await SharedDatabase.preview.loadExercises()
            return nil
        },
        content: { _ in
            WorkoutListNewScreen()
        }
    )
    .environment(\.database, SharedDatabase.preview.database)
    
    
}
