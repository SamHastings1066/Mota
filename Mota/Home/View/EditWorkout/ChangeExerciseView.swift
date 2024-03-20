//
//  ChangeExerciseView.swift
//  Mota
//
//  Created by sam hastings on 19/02/2024.
//

import SwiftUI

struct ChangeExerciseView: View {
    @Binding var selectedExercise: DatabaseExercise?
    @Binding var modelExercise: DatabaseExercise
    @State private var singleSelection: UUID?
    
    @State var isInfoPresented = false
    @State var exerciseToBePresented: DatabaseExercise?
    
    @State var filterString: String = ""
    
    var filteredExercises: [DatabaseExercise] {
        if filterString.isEmpty {
            return ExerciseDataLoader.shared.databaseExercises
        } else {
            return ExerciseDataLoader.shared.databaseExercises.filter { exercise in
                exercise.name.lowercased().contains(filterString.lowercased())
            }
        }
        
    }
    
    var body: some View {
        Text("Selected exercise: \(selectedExercise?.name ?? "")")
        TextField(
            "Filter exercises",
            text: $filterString
        )
        .padding(.leading)
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



//#Preview {
//    ChangeExerciseView(selectedExercise: .constant(databaseExercises[0]), modelExercise: .constant(databaseExercises[0]))
//}
