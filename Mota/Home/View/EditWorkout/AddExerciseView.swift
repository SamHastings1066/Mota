//
//  AddExerciseView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI

struct AddExerciseView: View {

    @Binding var isAddExercisePresented: Bool
    @State private var singleSelection: UUID?
    
    @State var isInfoPresented = false
    @State var exerciseToBePresented: Exercise?
    
    var addExerciseClosure: ((Exercise) -> Void)?
    
    var body: some View {
        List(exercises, selection: $singleSelection) { exercise in
            Button {
                addExerciseClosure?(exercise)
                //workout.addSuperset(SuperSet(exerciseRounds: [ExerciseRound(singleSets: [SingleSet(exercise: exercise, weight: 0, reps: 0)])]))
                isAddExercisePresented = false
            } label: {
                ExerciseRowView(exercise: exercise)
            }
            .swipeActions {
                Button("Burn") {
                    isInfoPresented.toggle()
                    exerciseToBePresented = exercise

                }
                .tint(.red)
            }
            .sheet(isPresented: $isInfoPresented) {
                ExerciseDetailView(isVisible: $isInfoPresented, exercise: exerciseToBePresented)
            }
        }
        .navigationTitle("Exercises")
    }
    
}

#Preview {
    AddExerciseView(isAddExercisePresented: .constant(true))
}


