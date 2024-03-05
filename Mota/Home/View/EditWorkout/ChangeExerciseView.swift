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
        List(selection: $singleSelection) {
            Section(header: Text("Swipe left for more info")) {
                ForEach(filteredExercises) { exercise in
                    Button {
                        modelExercise = exercise
                        selectedExercise = nil
                    } label: {
                        ExerciseRowView(exercise: exercise)
                    }
                    .swipeActions {
                        Button("Info") {
                            exerciseToBePresented = exercise
                            isInfoPresented.toggle()
                        }
                        .tint(.blue)
                    }
                    .sheet(isPresented: $isInfoPresented) {
                        ExerciseDetailView(exercise: exerciseToBePresented)
                    }
                    
                }
            }
        }
        .navigationTitle("Exercises")
    }
    
}



#Preview {
    ChangeExerciseView(selectedExercise: .constant(IdentifiableExercise(exercise: exercises[0])), modelExercise: .constant(exercises[0]))
}
