//
//  WorkoutViewModel.swift
//  Mota
//
//  Created by sam hastings on 12/02/2024.
//

import Foundation

class WorkoutViewModel {
    
    var workout: Workout
    
    init() {
        // TODO: remove - this is for debugging purposes
        let set1 =  SingleSet(exercise: exercises.first(where: { $0.id == "Barbell_Squat" }) ?? exercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let superSet1 = SuperSet(sets: [set1, set2], rest: 50, numRounds: 8)
        // Create second superset
        let set3 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 5)
        let set4 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let set5 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 4)
        let set6 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 40, reps: 6)
        let superSet2 = SuperSet(sets: [ExerciseRound(round: [set3, set4], rest:40), ExerciseRound(round: [set5,set6], rest: 50)])
        
        self.workout = Workout(supersets: [superSet1, superSet2])
    }
    
    func addSuperset(_ superSet: SuperSet) {
        print(workout.supersets.count)
        workout.addSuperset(superSet)
        print(workout.supersets.count)
    }
    
}
