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
    
    @State var isAddExercisePresented = false
    @State var selectedExercise: IdentifiableExercise?
    
    var imageName: String? {
        if let databaseExercise = exercise as? DatabaseExercise, !databaseExercise.imageURLs.isEmpty {
            return databaseExercise.imageURLs[0]
        } else {
            return nil
        }
    }
    
    var body: some View {
        HStack {
            
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
//            .fullScreenCover(isPresented: $isAddExercisePresented)
//            {
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

            
            
            VStack(alignment: .center) {
                Text(exercise.name)
                    .font(.headline)
                HStack{
                    VStack{
                        Text("Reps")
                        TextField("", value: $reps, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    VStack {
                        Text("kgs")
                        TextField("", value: $weight, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
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
