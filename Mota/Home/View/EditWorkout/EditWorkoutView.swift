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
    var workout: Workout {
        let set1 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let superSet1 = SuperSet(sets: [set1, set2], rest: 50, numRounds: 8)
        
        // Create second superset
        let set3 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        let set4 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(sets: [set3, set4], rest: 120, numRounds: 8)
        
        return Workout(supersets: [superSet1, superSet2])
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Exercise 1") ) {
                    //SupersetCollapsedView(superset: workout.supersets[0])
                    SupersetCollapsedView(viewModel: SuperSetViewModel(superset: workout.supersets[0]))
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

// TODO: Create VM for SupersetCollapsedView - this will convert the superset given to it into a list of subsets - a subset will have name, optional reps, optional weight
struct SupersetCollapsedView: View {
    var viewModel: SuperSetViewModel
    //var superset: SuperSet
    var body: some View {
        HStack {
            Text(viewModel.sets[0].name)
            //Text(superset.sets[0][0].exercise.name)
        }
    }
}


#Preview {
    EditWorkoutView()
}


