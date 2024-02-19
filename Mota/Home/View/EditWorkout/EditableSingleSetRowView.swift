//
//  EditableSingleSetRowView.swift
//  Mota
//
//  Created by sam hastings on 18/02/2024.
//


import SwiftUI

struct EditableSingleSetRowView: View {
    //@Binding var singleSet: SingleSet
    @Binding var exercise: Exercise
    @Binding var weight: Int?
    @Binding var reps: Int?
    
    @State var isAddExercisePresented = false
    @State var selectedExercise: Exercise?
    
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
                //print("Tapped")
            }) {
                SafeImage(imageName: imageName)
                    .frame(width: 70, height: 70)
                    //.padding(.trailing)
            }
            .onTapGesture {
                isAddExercisePresented.toggle()
            }
            .fullScreenCover(isPresented: $isAddExercisePresented)
            {
                NavigationStack() {
                    AddExerciseView()
                        .navigationBarItems(
                            leading: Button(action: {
                                isAddExercisePresented.toggle()
                            }) {
                                Text("Cancel")
                            }
                            
                        )
                        //.navigationBarTitle("Add Exercise", displayMode: .inline)
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
                        //Text("\(singleSet.reps.map{ "\($0)"} ?? "-")")
                    }
                    VStack {
                        Text("kgs")
                        TextField("", value: $weight, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        //Text("\(singleSet.weight.map{ "\($0)"} ?? "-")")
                    }
                }
                //Text("\(singleSet.reps.map{ "\($0)"} ?? "?") x \(singleSet.weight.map{ "\($0)"} ?? "?")")
                
                
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
        //EditableSingleSetRowView(singleSet: .constant(SingleSet(exercise: exercises[0], reps: 8)))
        //EditableSingleSetRowView(singleSet: .constant(SingleSet(exercise: UserDefinedExercise(name: "Squats"), weight: 60, reps: 10)))
    }
}
