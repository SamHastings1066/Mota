//
//  WorkoutListNewScreen.swift
//  Mota
//
//  Created by sam hastings on 15/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutListNewScreen: View {
    
    @State private var workouts: [WorkoutNew] = []
    @State private var sampleBackgroundExercises: [DatabaseExercise] = []
    @Environment(\.database) private var database
    @State private var path = [WorkoutNew]()
    
    
    private func createExampleWorkouts() async -> [WorkoutNew] {
        let startCreatingModels = Date()
        var rounds = [Round]()
        for _ in 0..<2000 {
            let round = Round(singlesets: [SinglesetNew(exercise: sampleBackgroundExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleBackgroundExercises[1], weight: 90, reps: 15)])
            rounds.append(round)
        }
        let workout1 = WorkoutNew(
            name: "Legs workout",
            supersets: [
                SupersetNew(
                    rounds: rounds
                )
            ]
        )
        
        let workout2 = WorkoutNew(name: "Arms workout",
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
            let newWorkout = WorkoutNew()
            await database.insert(newWorkout)
            try await database.save()
            path = [newWorkout]
            workouts.append(newWorkout)
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
            .navigationDestination(for: WorkoutNew.self) { workout in
                WorkoutNewScreen(workoutID: workout.id)
            }
            .toolbar {
                Button("Add Samples", action: addExampleWorkouts)
                Button("Add workout", systemImage: "plus", action: addNewWorkout)
            }
        }
        .task {
            do {
                let descriptor = FetchDescriptor<WorkoutNew>()
                workouts = try await database.fetch(descriptor)
                sampleBackgroundExercises = try await database.fetch(FetchDescriptor<DatabaseExercise>())
            } catch {
                
            }
        }
    }
}

#Preview {
    
    struct AsyncPreviewView: View {
        @State var loadingExercises = true
        
        var body: some View {
            if loadingExercises {
                ProgressView("loading exercises")
                    .task {
                        await SharedDatabase.preview.loadExercises()
                        loadingExercises = false
                    }
            } else {
                    WorkoutListNewScreen()
            }
        }
    }
    
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        return AsyncPreviewView()
            .environment(\.database, SharedDatabase.preview.database)
    } catch {
        fatalError("Failed to create model container")
    }
    
    
    
}
