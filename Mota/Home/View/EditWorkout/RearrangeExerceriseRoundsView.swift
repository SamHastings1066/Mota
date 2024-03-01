//
//  RearrangeExerceriseRoundsView.swift
//  Mota
//
//  Created by sam hastings on 29/02/2024.
//

import SwiftUI

struct RearrangeExerceriseRoundsView: View {
    
    @Binding var superSet: SuperSet
    
    var body: some View {
        
//        List(superSet!.identifiableExercises){ exercise in
//            ExerciseRowView(exercise: exercise.exercise)
//        }
        
        List {
            
                //TODO: need to make the next line $superSet somehow.
                ForEach($superSet.identifiableExercises) { $exercise in
                    ExerciseRowView(exercise: exercise.exercise)
                    //Text(exercise.exercise.name)
                }
                .onMove {
                    print("Moved")
                    superSet.identifiableExercises.move(fromOffsets: $0, toOffset: $1)
                }
            
        }
    }
}

#Preview {
    RearrangeExerceriseRoundsView(superSet: .constant(SuperSet(exerciseRounds: [ExerciseRound(singleSets: [SingleSet(exercise: UserDefinedExercise(name: "Squat")), SingleSet(exercise: UserDefinedExercise(name: "Deadlift"))])])))
}
