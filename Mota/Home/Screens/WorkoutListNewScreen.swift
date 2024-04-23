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
    
    
    func addSampleWorkouts() {
        let workout1 = WorkoutNew(
            name: "Legs workout",
            supersets: [
                SupersetNew(
                    rounds: [
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)]),
                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)])
                    ]
                    
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

        
        modelContext.insert(workout1)
        modelContext.insert(workout2)
    }
    
    private func removeWorkout(_ offsets: IndexSet) {
        for offset in offsets {
            let workout = workouts[offset]
            modelContext.delete(workout)
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
            .navigationDestination(for: WorkoutNew.self, destination: WorkoutNewScreen.init)
            .toolbar {
                Button("Add Samples", action: addSampleWorkouts)
                Button("Add workout", systemImage: "plus", action: addWorkout)
            }
        }
    }
}

#Preview {
    WorkoutListNewScreen()
}
