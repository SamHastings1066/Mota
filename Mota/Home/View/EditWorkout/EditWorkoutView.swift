//
//  EditWorkoutView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI

// TODO: set up the navigation first following the flow diagram I created.
// TODO: change this to "editWorkoutView"
// TODO: Create a View model for edit workout view. Takes workout data model and uses it to populate the EditWorkoutView.
// TODO: Create Datamodel for a workout including workout name, etc. The default value for the workout name is NewWorkout. It increments to New Workout 1, etc, if New Workout is taken. Use a binding to this observable object so that the user can edit the name


struct EditWorkoutView: View {
    
    @State var isAddExercisePresented = false
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Exercise 1") ) {
                    Text("Squat")
                }
                Section(header: Text("Exercise 2") ) {
                    Text("Bench press")
                }
                
                Button {
                    isAddExercisePresented.toggle()
                } label: {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                        Text("Add exercise")
                    }
                }
                
            }
            .fullScreenCover(isPresented: $isAddExercisePresented)
            {
                NavigationStack(path: $path) {
                    AddExerciseView(path: $path)
                        .navigationBarItems(
                            leading: Button(action: {
                                isAddExercisePresented.toggle()
                            }) {
                                Text("Cancel")
                            }//,
//                            trailing: Button(action: {
//                                // Add "Done" action here
//                            }) {
//                                
//                                Text("Done")
//                            }
//                                .disabled(false)
 
                        )
                        .navigationBarTitle("Add Exercise", displayMode: .inline)
                }
            }
            
            .navigationTitle("New Workout")
            
            
            
        }
    }
}

#Preview {
    EditWorkoutView()
}
