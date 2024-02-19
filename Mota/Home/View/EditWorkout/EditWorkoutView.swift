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
    @State var viewModel = WorkoutViewModel()
    
    // TODO: remove - this is for debugging purposes
    var dummySuperset: SuperSet {
        let set1 =  SingleSet(exercise: exercises.first(where: { $0.id == "Bench_Press_-_Powerlifting" }) ?? exercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: exercises.first(where: { $0.id == "Barbell_Deadlift" }) ?? exercises[0], weight: 50, reps: 6)
        return SuperSet(singleSets: [set1, set2], rest: 50, numRounds: 8)
    }
    
    var body: some View {
        NavigationStack {
            ExerciseListView(workout: $viewModel.workout)
                .environment(viewModel)
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
            //            .fullScreenCover(isPresented: $isAddExercisePresented)
            //            {
            //                NavigationStack() {
            //                    AddExerciseView()
            //                        .navigationBarItems(
            //                            leading: Button(action: {
            //                                isAddExercisePresented.toggle()
            //                            }) {
            //                                Text("Cancel")
            //                            }
            //
            //                        )
            //                        .navigationBarTitle("Add Exercise", displayMode: .inline)
            //                }
            //            }
            .navigationTitle("New Workout")
        }
    }
}

struct ExerciseListView: View {
    @Binding var workout: Workout
    var body: some View {
        List {
            
            ForEach(workout.supersets.indices, id: \.self) { index in
                Section(header: Text("Set \(index + 1)")) {
                    // Create a binding to the individual superset
                    ExerciseView(superSet: $workout.supersets[index])
                }
            }
            //                .onMove(perform: { indices, newOffset in
            //                    workout.supersets.move(fromOffsets: indices, toOffset: newOffset)
            //                })
        }
    }
}

struct ExerciseView: View {
    @State private var isChevronTapped = false
    @State private var isEditting = false
    @Binding var superSet: SuperSet
    
    //@State var superset: SuperSet
    var body: some View {
        HStack {
            Spacer()
            ChevronButton(isChevronTapped: $isChevronTapped)
            Spacer()
            EditButton(isEditting: $isEditting)
        }
        // TODO: Remove this switch and make it a simple if-else on chevrontapped
        if isChevronTapped {
            ExpandedSupersetEditView(superSet: $superSet, isEditable: isEditting, isExpanded: isChevronTapped)
        } else {
            CollapsedSupersetEditView(superSet: $superSet, isEditable: isEditting)
        }
        
    }
}

//struct CollapsedSupersetView: View {
//    var collapsedSuperset: SuperSet.CollapsedSuperset
//    var superSet: SuperSet
//    //var singleSet: SingleSet
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                
//                ForEach(collapsedSuperset.superSetRepresentation.singleSets) { singleSet in
//                    SingleSetRowView(singleSet: singleSet)
//                }
//            }
//            Spacer()
//            VStack(alignment: .center){
//                VStack {
//                    Text("Rounds")
//                        .font(.headline)
//                    Text("\(collapsedSuperset.numRounds)")
//                }
//                
//                VStack {
//                    Text("Rest")
//                        .font(.headline)
//                    Text("\(collapsedSuperset.superSetRepresentation.rest.map{ "\($0)" } ?? "-")")
//                }
//            }
//            .padding(.all, 10)
//            .background(Color(UIColor.systemGray5))
//            .cornerRadius(10)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}

struct CollapsedSupersetEditView: View {
    //@Binding var collapsedSuperset: SuperSet.CollapsedSuperset
    //@Binding var superSetCollapsedRepresentation: ExerciseRound
    // TODO: Delete numRounds when ready
    //@Binding var numRounds: Int
    @Binding var superSet: SuperSet
    var isEditable = true
    // TODO: remove this vr, only for experimentation purposes.
    @Environment(WorkoutViewModel.self) private var viewModel
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                ForEach( 0..<superSet.consistentExercises.count, id: \.self ) { exerciseNumber in
                    EditableSingleSetRowView(exercise: $superSet.consistentExercises[exerciseNumber], weight: $superSet.consistentWeights[exerciseNumber], reps: $superSet.consistentReps[exerciseNumber],
                                             isEditable: isEditable
                    )
                }
            }
            Spacer()
            VStack(alignment: .center){
                VStack {
                    Text("Rounds")
                        .font(.headline)
                    if isEditable {
                        TextField("", value: $superSet.numRounds, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else {
                        Text("\(superSet.numRounds)")
                    }
                }
                
                VStack {
                    Text("Rest")
                        .font(.headline)
                    if isEditable {
                        TextField("", value: $superSet.constistentRest, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else {
                        Text("\(superSet.constistentRest.map{ "\($0)" } ?? "-")")
                    }
                }
            }
            .padding(.all, 10)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(10)
            .fixedSize(horizontal: true, vertical: false)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ChevronButton: View {
    @Binding var isChevronTapped: Bool
    var body: some View {
        Button(action: {
            // leave blank and use .onTapGesture to allow both buttons to function within the same Hstack
        }) {
            Image(systemName: isChevronTapped ? "chevron.up" : "chevron.down")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
        }
        .onTapGesture {
            withAnimation{
                isChevronTapped.toggle()
            }
        }
    }
}

struct EditButton: View {
    @Binding var isEditting: Bool
    var body: some View {
        Button(action: {
            // leave blank and use .onTapGesture to allow both buttons to function within the same Hstack
        }) {
            Text( isEditting ? "Done" : "Edit")
        }
        .onTapGesture {
            withAnimation{
                isEditting.toggle()
            }
        }
    }
}

//struct ExpandedSupersetView: View {
//    var superset: SuperSet
//    var body: some View {
//        ForEach(superset.exerciseRounds) { exerciseRound in
//            ForEach(exerciseRound.singleSets) { singleset in
//                SingleSetRowView(singleSet: singleset)
//            }
//            HStack {
//                Spacer()
//                VStack {
//                    Text("Rest")
//                        .font(.headline)
//                    Text("\(exerciseRound.rest.map{ "\($0)" } ?? "-")")
//                }
//                Spacer()
//            }
//        }
//    }
//}

struct ExpandedSupersetEditView: View {
    @Binding var superSet: SuperSet
    var isEditable = true
    var isExpanded = false
    var body: some View {
        ForEach( 0..<superSet.numRounds, id: \.self ) { roundNumber in
            ForEach( 0..<superSet.exerciseRounds[roundNumber].singleSets.count, id: \.self ) { exerciseNumber in
                EditableSingleSetRowView(exercise: $superSet.exerciseRounds[roundNumber].singleSets[exerciseNumber].exercise, weight: $superSet.exerciseRounds[roundNumber].singleSets[exerciseNumber].weight, reps: $superSet.exerciseRounds[roundNumber].singleSets[exerciseNumber].reps,
                                         isEditable: isEditable, isExpanded: isExpanded
                )
            }
            HStack {
                Spacer()
                VStack {
                    Text("Rest")
                        .font(.headline)
                    if isEditable {
                        TextField("", value: $superSet.exerciseRounds[roundNumber].rest, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else {
                        Text("\(superSet.exerciseRounds[roundNumber].rest.map{ "\($0)" } ?? "-")")
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    EditWorkoutView()
}
