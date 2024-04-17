//
//  WorkoutListNewScreen.swift
//  Mota
//
//  Created by sam hastings on 15/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutListNewScreen: View {
    
    @Query private var workouts: [Workout]
    @Environment(\.modelContext) private var modelContext
    @State private var path = [Workout]()
    
    func addSampleWorkouts() {
        let databaseExercises = DatabaseExercise.sampleExercises
        
        let set1Exercise0Weight100Reps5 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2Exercise1Weight50Reps6 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3Exercise0Weight120Reps4 =  SingleSet(exercise: databaseExercises[0], weight: 120, reps: 4)
//        modelContext.insert(set1Exercise0Weight100Reps5)
//        modelContext.insert(set2Exercise1Weight50Reps6)
//        modelContext.insert(set3Exercise0Weight120Reps4)
//        let set4Exercise1Weight40Reps7 = SingleSet(exercise: databaseExercises[1], weight: 40, reps: 7)
//        let set5Exercise0Weight100Reps11 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 11)
//        let set6Exercise1Weight15Reps30 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 15, reps: 30)
//        let set7Exercise0Weight120Reps8 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
//        let set8Exercise1Weight30Reps9 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        
        
        let exerciseRound1 = ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6])
        //modelContext.insert(exerciseRound1)
        let superset1 = SuperSet(exerciseRounds: [exerciseRound1])
        
        
        let workout1 = Workout(supersets: [superset1])
        //superset1.workout = workout1
        workout1.name = "Dummy workout"
        
        let exerciseRound2 = ExerciseRound(singleSets: [set3Exercise0Weight120Reps4])
        let superset2 = SuperSet(exerciseRounds: [ExerciseRound](repeating: exerciseRound2, count: 10))
        //let superset2 = SuperSet(exerciseRounds: [exerciseRound2])
        let workout2 = Workout(supersets: [superset2])
        workout2.name = "Dummy workout 2"
        
        modelContext.insert(workout1)
        modelContext.insert(workout2)
        
        //superset1.workout = workout1 //causes error
        
    }
    
    private func removeWorkout(_ offsets: IndexSet) {
        for offset in offsets {
            let workout = workouts[offset]
            modelContext.delete(workout)
        }
    }
    
    func addWorkout() {
        let newWorkout = Workout()
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
            .navigationDestination(for: Workout.self, destination: WorkoutNewScreen.init)
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
