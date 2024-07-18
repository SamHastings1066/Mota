//
//  WorkoutListNewScreen.swift
//  Mota
//
//  Created by sam hastings on 15/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutListNewScreen: View {
    
    @State private var backgroundWorkouts: [WorkoutNew] = []
    @State private var sampleBackgroundExercises: [DatabaseExercise] = []
    @Environment(\.database) private var database
    @State private var path = [WorkoutNew]()
    
    
    private func createBackgroundWorkouts() async -> [WorkoutNew] {
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
    
    private func addBackgroundWorkouts() {
        Task {
            let workouts = await createBackgroundWorkouts()
            
            
            let startInsertingModels = Date()
            for workout in workouts {
                await database.insert(workout)
            }
            print("Time to insert models: \(Date().timeIntervalSince(startInsertingModels))")
            do {
                try await database.save()
                let descriptor = FetchDescriptor<WorkoutNew>()
                backgroundWorkouts = try await database.fetch(descriptor)
            } catch {
                print(error)
            }
        }
    }
    
    private func removeBackgroundWorkout(_ offsets: IndexSet) {
        Task {
            let startDeletingModels = Date()
            for offset in offsets {
                let workout = backgroundWorkouts[offset]
                await database.delete(workout) // causes error
            }
            print("Time to Delete models: \(Date().timeIntervalSince(startDeletingModels))")
            do {
                try await database.save()
                let descriptor = FetchDescriptor<WorkoutNew>()
                backgroundWorkouts = try await database.fetch(descriptor) // causing error
            } catch {
                print(error)
            }
        }
    }
    
    func addBackgroundWorkout() {
        Task {
            let newWorkout = WorkoutNew()
            await database.insert(newWorkout)
            try await database.save()
            path = [newWorkout]
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(backgroundWorkouts) { workout in
                    NavigationLink(value: workout) {
                        Text(workout.name)
                            .font(.headline)
                    }
                }
                .onDelete(perform: removeBackgroundWorkout)
            }
            .navigationTitle("Workout List")
            .navigationDestination(for: WorkoutNew.self) { workout in
                WorkoutNewScreen(workoutID: workout.id)
            }
            .toolbar {
                Button("Add Samples", action: addBackgroundWorkouts)
                Button("Add workout", systemImage: "plus", action: addBackgroundWorkout)
            }
        }
        .task {
            do {
                let descriptor = FetchDescriptor<WorkoutNew>()
                backgroundWorkouts = try await database.fetch(descriptor)
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
