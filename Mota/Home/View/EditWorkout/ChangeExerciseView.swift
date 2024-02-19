//
//  ChangeExerciseView.swift
//  Mota
//
//  Created by sam hastings on 19/02/2024.
//

import SwiftUI


import SwiftUI

struct ChangeExerciseView: View {
    
    @Binding var selectedExercise: IdentifiableExercise?
    @Binding var modelExercise: Exercise
    @State private var singleSelection: UUID?
    
    var body: some View {
        Text("Selected exercise: \(selectedExercise?.exercise.name ?? "")")
        List(exercises, selection: $singleSelection) { exercise in
            Button {
                modelExercise = exercise
                selectedExercise = nil
            } label: {
                ExerciseRowView(exercise: exercise)
            }

            
        }
        .navigationTitle("Exercises")
    }
    
}



#Preview {
    ChangeExerciseView(selectedExercise: .constant(IdentifiableExercise(exercise: exercises[0])), modelExercise: .constant(exercises[0]))
}
