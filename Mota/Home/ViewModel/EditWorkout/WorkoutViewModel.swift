//
//  WorkoutViewModel.swift
//  Mota
//
//  Created by sam hastings on 12/02/2024.
//

import Foundation

@Observable
class WorkoutViewModel {
    
    var workout: Workout
    
    init() {
        // TODO: remove - this is for debugging purposes
        let set1 =  SingleSet(exercise: exercises.first(where: { $0.id == "Barbell_Squat" }) ?? exercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: exercises.first(where: { $0.id == "Bench_Press_-_Powerlifting" }) ?? exercises[0], weight: 50, reps: 6)
        let set3 = SingleSet(exercise: exercises.first(where: { $0.id == "90_90_Hamstring" }) ?? exercises[0], weight: 40, reps: 9)
        let superSet1 = SuperSet(singleSets: [set1, set2, set3], rest: 50, numRounds: 8)
        // Create second superset
        let set4 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 5)
        let set5 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let set6 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 4)
        let set7 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 40, reps: 6)
        let superSet2 = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set4, set5], rest:40), ExerciseRound(singleSets: [set6,set7], rest: 50)])
        
        self.workout = Workout(supersets: [superSet1, superSet2])
    }
    
    func addSuperset(_ superSet: SuperSet) {
        print(workout.supersets.count)
        workout.addSuperset(superSet)
        print(workout.supersets.count)
    }
    
}
