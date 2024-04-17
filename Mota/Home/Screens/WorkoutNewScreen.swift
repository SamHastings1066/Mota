//
//  WorkoutNewScreen.swift
//  Mota
//
//  Created by sam hastings on 16/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutNewScreen: View {
    
    @Bindable var workout: Workout
    
    var body: some View {
        List {
            Text("Placeholder")
            //ForEach(workout.supersets) { superset in
                //Text("test")
                //                SupersetNewView()
            //}
        }
        .onAppear{
            print(workout.name)
            print(workout.supersets.count)
        }
            .navigationTitle(workout.name)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, configurations: config)
        
        let databaseExercises = DatabaseExercise.sampleExercises
        let set1Exercise0Weight100Reps5 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let exerciseRound1 = ExerciseRound(singleSets: [set1Exercise0Weight100Reps5])
        let superset1 = SuperSet(exerciseRounds: [exerciseRound1])
        let workout1 = Workout(supersets: [superset1])
        workout1.name = "Dummy workout"
        
        return WorkoutNewScreen(workout: workout1)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
