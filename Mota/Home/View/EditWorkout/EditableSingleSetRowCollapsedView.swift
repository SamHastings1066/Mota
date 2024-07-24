//
//  EditableSingleSetRowCollapsedView.swift
//  Mota
//
//  Created by sam hastings on 05/03/2024.
//

import SwiftUI

struct EditableSingleSetRowCollapsedView: View {
    @Binding var exercise: DatabaseExercise
    @Binding var weight: Int?
    @Binding var reps: Int?
    
    var isEditable = true
    var removeExerciseClosure: (() -> Void)?
    
    @State var isChangeExercisePresented = false
    @State var isExerciseDetailPresented = false
    @State var selectedExercise: DatabaseExercise?
    
    // Computed properties for TextField bindings
    private var weightString: Binding<String> {
        Binding<String>(
            get: {
                if let weight = weight {
                    return String(weight)
                } else {
                    return ""
                }
            },
            set: {
                if let number = Int($0) {
                    weight = number
                } else if $0.isEmpty {
                    weight = nil
                }
            }
        )
    }
    
    private var repsString: Binding<String> {
        Binding<String>(
            get: {
                if let reps = reps {
                    return String(reps)
                } else {
                    return ""
                }
            },
            set: {
                if let number = Int($0) {
                    reps = number
                } else if $0.isEmpty {
                    reps = nil
                }
            }
        )
    }
    
    
    var imageNames: [String?] {
        if !exercise.imageURLs.isEmpty {
            return [exercise.imageURLs[0], exercise.imageURLs[1]]
        } else {
            return [nil,nil]
        }
    }
    
    var body: some View {
        HStack {
            if isEditable {
                VStack {
                    Button(action: {
                        
                    }) {
                        ExerciseAnimationView(imageNames: imageNames, fullSizeImageURLs: [nil, nil])
                            .frame(width: 70, height: 70)
                    }
                    .onTapGesture {
                        isChangeExercisePresented.toggle()
                        selectedExercise = exercise
                    }
                    .fullScreenCover(item: $selectedExercise)
                    { exercise in
                        NavigationStack() {
                            ChangeExerciseView(selectedExercise: $selectedExercise, modelExercise: $exercise)
                                .navigationBarItems(
                                    leading: Button(action: {
                                        //isSetExercisePresented.toggle()
                                        selectedExercise = nil
                                    }) {
                                        Text("Cancel")
                                    }
                                )
                        }
                    }
                    DeleteItemButton {
                        removeExerciseClosure?()
                    }
                }
            } else {
                Button {
                    
                } label: {
                    ExerciseAnimationView(imageNames: imageNames, fullSizeImageURLs: [nil,nil])
                        .frame(width: 70, height: 70)
                }
                .onTapGesture {
                    isExerciseDetailPresented.toggle()
                    
                }
                .sheet(isPresented: $isExerciseDetailPresented) {
                    ExerciseDetailScreen(exercise: exercise)
                }
            }
            
            SinglesetInfoView(name: exercise.name, reps: repsString, weight: weightString, isEditable: isEditable)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            
        }
        .padding([.vertical, .leading], 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}


//#Preview {
// 
//    Group {
//        EditableSingleSetRowCollapsedView(exercise: .constant(DatabaseExercise.sampleExercises[0]), weight: .constant(nil), reps: .constant(12))
//        EditableSingleSetRowCollapsedView(exercise: .constant(DatabaseExercise.sampleExercises[1]), weight: .constant(60), reps: .constant(10))
//    }
//}
