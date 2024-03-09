//
//  RearrangeExerceriseRoundsView.swift
//  Mota
//
//  Created by sam hastings on 29/02/2024.
//

import SwiftUI

struct RearrangeExerceriseRoundsView: View {
    
    @Bindable var superSet: SuperSet
    
    var body: some View {
        
        List {
            ForEach($superSet.identifiableExercises) { $exercise in
                    ExerciseRowView(exercise: exercise)
                    //Text(exercise.exercise.name)
                }
                .onMove {
                    superSet.identifiableExercises.move(fromOffsets: $0, toOffset: $1)
                }
            
        }
    }
}

//#Preview {
//    var dummySuperset = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 0, reps: 0), SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 0, reps: 0)])])
//    return RearrangeExerceriseRoundsView(superSet: dummySuperset)
//}
