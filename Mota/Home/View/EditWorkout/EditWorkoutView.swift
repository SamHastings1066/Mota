//
//  EditWorkoutView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI

// TODO: Create a View model for edit workout view. Takes workout data model and uses it to populate the EditWorkoutView.
// TODO: Create Datamodel for a workout including workout name, etc. The default value for the workout name is NewWorkout. It increments to New Workout 1, etc, if New Workout is taken. Use a binding to this observable object so that the user can edit the name


struct EditWorkoutView: View {
    
    @State var isAddExercisePresented = false
    
    let viewModel = WorkoutViewModel()
    
    // TODO: remove - this is for debugging purposes
    var dummySuperset: SuperSet {
        let set1 =  SingleSet(exercise: exercises.first(where: { $0.id == "Bench_Press_-_Powerlifting" }) ?? exercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: exercises.first(where: { $0.id == "Barbell_Deadlift" }) ?? exercises[0], weight: 50, reps: 6)
        return SuperSet(sets: [set1, set2], rest: 50, numRounds: 8)
    }

    var workout: Workout { viewModel.workout }
    
    var body: some View {
        NavigationStack {
            
            
            List {
                ForEach(Array(workout.supersets.enumerated()), id: \.element.id) { (index, superset) in
                    Section(header: Text("Exercise \(index + 1)" )) {
                        ExerciseView(superset: superset)
                    }
                }
//                .onMove(perform: { indices, newOffset in
//                    workout.supersets.move(fromOffsets: indices, toOffset: newOffset)
//                })
            }

            
            
            Button {
                //isAddExercisePresented.toggle()
                //print(viewModel.workout.supersets.count)
                viewModel.addSuperset(dummySuperset)
                //print(viewModel.workout.supersets.count)
            } label: {
                HStack{
                    Image(systemName: "plus.circle.fill")
                    Text("Add exercise")
                }
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
        // Option 1
        HStack {
            VStack(alignment: .leading) {
                
                ForEach(collapsedSuperset.setRepresentation.rounds) { singleSet in
                    SingleSetRowView(singleSet: singleSet)
                }
//                .onMove(perform: { indices, newOffset in
//                    collapsedSuperset.setRepresentation.rounds.move(fromOffsets: indices, toOffset: newOffset)
//                                })
                
                
                // Option 2
//                HStack(alignment: .center){
//                    VStack {
//                        Text("Rounds")
//                            .font(.headline)
//                        Text("\(collapsedSuperset.numRounds)")
//                    }
//                    
//                    VStack {
//                        Text("Rest")
//                            .font(.headline)
//                        Text("\(collapsedSuperset.setRepresentation.rest.map{ "\($0)" } ?? "-")")
//                    }
//                }
//                .padding(.all, 10)
//                .background(Color(UIColor.systemGray5))
//                .cornerRadius(10)
                
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





struct ChevronButton: View {
    @Binding var isChevronTapped: Bool
    var body: some View {
        Button(action: {
            withAnimation{
                isChevronTapped.toggle()
            }
        }) {
            Image(systemName: isChevronTapped ? "chevron.up" : "chevron.down")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
        }
    }
}



struct ExpandedSupersetView: View {
    var superset: SuperSet
    var body: some View {
        ForEach(superset.sets) { round in
            ForEach(round.round) { singleset in
                SingleSetRowView(singleSet: singleset)
            }
            
            HStack {
                Spacer()
                VStack {
                    Text("Rest")
                        .font(.headline)
                    Text("\(round.rest)")
                }
                Spacer()
            }
            
        }
    }
}

struct ExerciseView: View {
    @State private var isChevronTapped: Bool = false
    var superset: SuperSet
    var body: some View {
        HStack {
            Spacer()
            ChevronButton(isChevronTapped: $isChevronTapped)
            Spacer()
        }
        if isChevronTapped {
            ExpandedSupersetView(superset: superset)
        } else {
            CollapsedSupersetView(collapsedSuperset: SuperSetViewModel(superset: superset).collapsedSuperset)
        }
    }
}

#Preview {
    EditWorkoutView()
}
