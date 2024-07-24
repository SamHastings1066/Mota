//
//  AddExerciseView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI
import SwiftData

//struct AddExerciseView: View {
//    @State private var singleSelection: UUID?
//    @State var exerciseToBePresented: DatabaseExercise?
//    
//    @State var filterString: String = ""
//    
//    var filteredExercises: [DatabaseExercise] {
//        if filterString.isEmpty {
//            return exercisesQuery
//        } else {
//            return exercisesQuery.filter { exercise in
//                exercise.name.lowercased().contains(filterString.lowercased())
//            }
//        }
//    }
//    
//    @Query(sort: \DatabaseExercise.name, order: .forward) var exercisesQuery: [DatabaseExercise]
//    
//    var addExerciseClosure: ((DatabaseExercise) -> Void)?
//    var body: some View {
//        TextField(
//            "Filter exercises",
//            text: $filterString
//        )
//        .padding(.leading)
//        List(selection: $singleSelection) {
//            Section(header: Text("Swipe left for more info")) {
//                ForEach(filteredExercises) { exercise in
//                    Button {
//                        addExerciseClosure?(exercise)
//                    } label: {
//                        ExerciseRowView(exercise: exercise)
//                    }
//                    .swipeActions {
//                        Button("Info") {
//                            exerciseToBePresented = exercise
//                        }
//                        .tint(.blue)
//                    }
//                }
//            }
//        }
//        .sheet(item: $exerciseToBePresented) { exercise in
//            ExerciseDetailScreen(exercise: exercise)
//        }
//        .navigationTitle("Exercises")
//    }
//    
//}

//#Preview {
//    AddExerciseView()
//}


