//
//  EditableSingleSetRowView.swift
//  Mota
//
//  Created by sam hastings on 18/02/2024.
//


import SwiftUI

struct EditableSingleSetRowView: View {
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
    
    var imageName: String? {
        if let databaseExercise = exercise as? DatabaseExercise, !databaseExercise.imageURLs.isEmpty {
            return databaseExercise.imageURLs[0]
        } else {
            return nil
        }
    }
    
    func getFocus(focused: Bool) {
        print("get focus:\(focused ? "true" : "false")")
    }
    
    var body: some View {
        HStack {
            if isEditable && !isExpanded {
                VStack {
                    Button(action: {
                        
                    }) {
                        SafeImage(imageName: imageName)
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
                SafeImage(imageName: imageName)
                    .frame(width: 70, height: 70)
            }
            
            
            
            VStack(alignment: .center) {
                Text(exercise.name)
                    .font(.headline)
                HStack{
                    VStack{
                        Text("Reps")
                        if isEditable {
                            TextField("", value: $reps, formatter: NumberFormatter(), onEditingChanged: getFocus)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        } else {
                            Text("\(reps.map{ "\($0)"} ?? "-")")
                        }
                    }
                    VStack {
                        Text("kgs")
                        if isEditable {
                            TextField("", value: $weight, formatter: NumberFormatter())
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
    Group {
        EditableSingleSetRowView(exercise: .constant(exercises[0]), weight: .constant(nil), reps: .constant(8))
        EditableSingleSetRowView(exercise: .constant(UserDefinedExercise(name: "Squats")), weight: .constant(60), reps: .constant(10))
    }
}
