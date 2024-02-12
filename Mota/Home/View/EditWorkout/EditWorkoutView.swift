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
        // Create first superset
        let set1 =  SingleSet(exercise: exercises.first(where: { $0.id == "Barbell_Squat" }) ?? exercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let superSet1 = SuperSet(sets: [set1, set2], rest: 50, numRounds: 8)
        
        // Create second superset
        let set3 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 5)
        let set4 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let set5 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 4)
        let set6 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 40, reps: 6)
        let superSet2 = SuperSet(sets: [(set: [set3, set4], rest:40), (set: [set5,set6], rest: 50)])
        
        return Workout(supersets: [superSet1, superSet2])
    }
    
    var body: some View {
        NavigationStack {
            
            
            List {
                ForEach(Array(workout.supersets.enumerated()), id: \.element.id) { (index, superset) in
                    Section(header: Text("Exercise \(index + 1)" )) {
                        CollapsedSupersetView(collapsedSuperset: SuperSetViewModel(superset: superset).collapsedSuperset)
                    }
                }
            }
            
            
            Button {
                isAddExercisePresented.toggle()
            } label: {
                HStack{
                    Image(systemName: "plus.circle.fill")
                    Text("Add exercise")
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
                            }
                            
                        )
                        .navigationBarTitle("Add Exercise", displayMode: .inline)
                }
            }
            
            .navigationTitle("New Workout")
            
            
            
        }
    }
}


struct CollapsedSupersetView: View {
    var collapsedSuperset: CollapsedSuperset
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                ForEach(collapsedSuperset.setRepresentation.rounds) { singleSet in
                    SingleSetRowView(singleSet: singleSet)
                }
                
            }
            
            Spacer()
            VStack(alignment: .center){
                VStack {
                    Text("Rounds")
                        .font(.headline)
                    Text("\(collapsedSuperset.numRounds)")
                }
                
                VStack {
                    Text("Rest")
                        .font(.headline)
                    Text("\(collapsedSuperset.setRepresentation.rest.map{ "\($0)" } ?? "-")")
                }
            }
            .padding(.all, 10)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    EditWorkoutView()
}


