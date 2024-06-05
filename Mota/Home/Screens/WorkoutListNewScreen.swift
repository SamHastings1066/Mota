//
//  WorkoutListNewScreen.swift
//  Mota
//
//  Created by sam hastings on 15/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutListNewScreen: View {
    
    @Query private var workouts: [WorkoutNew]
    @Environment(\.modelContext) private var modelContext
    @State private var path = [WorkoutNew]()
    @Query ( filter: #Predicate<DatabaseExercise> {
        $0.id.localizedStandardContains("Barbell_Squat") ||
        $0.id.localizedStandardContains("Barbell_Deadlift") ||
        $0.id.localizedStandardContains("Barbell_Bench_Press_-_Medium_Grip") ||
        $0.id.localizedStandardContains("Seated_Cable_Rows")
        
    }) var sampleExercises: [DatabaseExercise]
    
    
    private func createSampleWorkouts() async -> [WorkoutNew] {
        let startCreatingModels = Date()
        var rounds = [Round]()
        for _ in 0..<20000 {
            let round = Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)])
            rounds.append(round)
        }
        let workout1 = WorkoutNew(
            name: "Legs workout",
            supersets: [
                SupersetNew(
                    rounds: rounds
                ),
                SupersetNew(
                    rounds: [
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[2], weight: 10, reps: 20), SinglesetNew(exercise: sampleExercises[3], weight: 40, reps: 3)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[2], weight: 10, reps: 20), SinglesetNew(exercise: sampleExercises[3], weight: 40, reps: 3)])
                    ]
                )
            ]
        )
        
        let workout2 = WorkoutNew(name: "Arms workout",
                                  supersets: [
                                    SupersetNew(
                                        rounds: [
                                            Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)])
                                        ]
                                    ),
                                    SupersetNew(
                                        rounds: [
                                            Round(singlesets: [SinglesetNew(exercise: sampleExercises[2], weight: 10, reps: 20)]),
                                        ]
                                    )
                                  ]
        )
        print("Time to create models: \(Date().timeIntervalSince(startCreatingModels))")
        
        return [workout1, workout2]
    }
    
    private func addSampleWorkouts() {
        Task {
            let workouts = await createSampleWorkouts()
            
            await MainActor.run {
                let startInsertingModels = Date()
                workouts.forEach { modelContext.insert($0) }
                print("Time to insert models: \(Date().timeIntervalSince(startInsertingModels))")
            }
        }
    }
    
    private func removeWorkout(_ offsets: IndexSet) {
        Task {
            await MainActor.run {
                for offset in offsets {
                    let workout = workouts[offset]
                    modelContext.delete(workout)
                }
            }
        }
    }
    
    func addWorkout() {
        let newWorkout = WorkoutNew()
        modelContext.insert(newWorkout)
        path = [newWorkout]
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
                WorkoutNewScreen(workout: workout)
            }
            .toolbar {
                Button("Add Samples", action: addSampleWorkouts)
                Button("Add workout", systemImage: "plus", action: addWorkout)
            }
        }
    }
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        // check we haven't already added the exercises
        let descriptor = FetchDescriptor<DatabaseExercise>()
        let existingExercises = try container.mainContext.fetchCount(descriptor)
        guard existingExercises == 0 else { return WorkoutListNewScreen().modelContainer(container) }
        
        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
            fatalError("Failed to find exercises.json")
        }
        let data = try Data(contentsOf: url)
        let exercises = try JSONDecoder().decode([DatabaseExercise].self, from: data)
        for exercise in exercises {
            container.mainContext.insert(exercise)
        }
        print("DATABASE created")
        
        
        return NavigationStack{
            WorkoutListNewScreen()
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
    
    
}
