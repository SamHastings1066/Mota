//
//  EditableSingleSetRowCollapsedView.swift
//  Mota
//
//  Created by sam hastings on 05/03/2024.
//

import SwiftUI

struct EditableSingleSetRowCollapsedView: View {
    //@Binding var singleSet: SingleSet
    // TODO: This binding to exercise must be changed when a user selects a differnt exercise on the following screen
    @Binding var exercise: Exercise
    @Binding var weight: Int?
    @Binding var reps: Int?
    
    var isEditable = true
    var isExpanded = false
    var removeExerciseClosure: (() -> Void)?
    
    @State var isAddExercisePresented = false
    @State var selectedExercise: IdentifiableExercise?
    
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
        if let databaseExercise = exercise as? DatabaseExercise, !databaseExercise.imageURLs.isEmpty {
            return [databaseExercise.imageURLs[0], databaseExercise.imageURLs[1]]
        } else {
            return [nil,nil]
        }
    }
    
    var body: some View {
        HStack {
            if isEditable && !isExpanded {
                VStack {
                    Button(action: {
                        
                    }) {
                        //                        SafeImage(imageName: imageName)
                        exerciseAnimationView(imageNames: imageNames)
                            .frame(width: 70, height: 70)
                        //.padding(.trailing)
                    }
                    .onTapGesture {
                        isAddExercisePresented.toggle()
                        selectedExercise = IdentifiableExercise(exercise: exercise)
                    }
                    .fullScreenCover(item: $selectedExercise)
                    { exercise in
                        NavigationStack() {
                            ChangeExerciseView(selectedExercise: $selectedExercise, modelExercise: $exercise)
                                .navigationBarItems(
                                    leading: Button(action: {
                                        //isAddExercisePresented.toggle()
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
                //                SafeImage(imageName: imageName)
                exerciseAnimationView(imageNames: imageNames)
                    .frame(width: 70, height: 70)
            }
            
            
            
            VStack(alignment: .center) {
                Text(exercise.name)
                    .font(.headline)
                HStack{
                    VStack{
                        Text("Reps")
                        if isEditable {
                            //                            TextField("", value: $reps, formatter: NumberFormatter())
                            //                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            //                                .keyboardType(.numberPad)
                            TextField("", text: repsString)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        } else {
                            Text("\(reps.map{ "\($0)"} ?? "-")")
                        }
                    }
                    VStack {
                        Text("kgs")
                        if isEditable {
                            //                            TextField("", value: $weight, formatter: NumberFormatter())
                            //                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            //                                .keyboardType(.numberPad)
                            TextField("", text: weightString)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                        } else {
                            Text("\(weight.map{ "\($0)"} ?? "-")")
                        }
                    }
                }
                
            }
            Spacer()
            
            
        }
        .padding([.vertical, .leading], 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}

#Preview {
    //var dummyWeight: Int? = nil
    Group {
        EditableSingleSetRowCollapsedView(exercise: .constant(exercises[0]), weight: .constant(nil), reps: .constant(12))
        EditableSingleSetRowCollapsedView(exercise: .constant(UserDefinedExercise(name: "Squats")), weight: .constant(60), reps: .constant(10))
    }
}
