//
//  ChangeExerciseView.swift
//  Mota
//
//  Created by sam hastings on 19/02/2024.
//

import SwiftUI

struct ChangeExerciseView: View {
    
    @Binding var selectedExercise: IdentifiableExercise?
    @Binding var modelExercise: Exercise
    @State private var singleSelection: UUID?
    
    @State var isInfoPresented = false
    @State var exerciseToBePresented: Exercise?
    
    @State var filterString: String = ""
    
    var filteredExercises: [DatabaseExercise] {
        if filterString.isEmpty {
            return exercises
        } else {
            return exercises.filter { exercise in
                exercise.name.lowercased().contains(filterString.lowercased())
            }
        }
        
    }
    
    var body: some View {
        Text("Selected exercise: \(selectedExercise?.exercise.name ?? "")")
        TextField(
            "Filter exercises",
            text: $filterString
        )
        List(filteredExercises, selection: $singleSelection) { exercise in
            Button {
                modelExercise = exercise
                selectedExercise = nil
            } label: {
                ExerciseRowView(exercise: exercise)
            }
            .swipeActions {
                Button("Info") {
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
    ChangeExerciseView(selectedExercise: .constant(IdentifiableExercise(exercise: exercises[0])), modelExercise: .constant(exercises[0]))
}
