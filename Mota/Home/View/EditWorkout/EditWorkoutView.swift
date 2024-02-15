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
        return SuperSet(sets: [set1, set2], rest: 50, numRounds: 8)
    }

    //var workout: Workout { viewModel.workout }
    
    //@State var workout2 = WorkoutViewModel().workout
    //@State var viewModel2 = WorkoutViewModel()
    //var workout2: Workout { viewModel2.workout }
    
    
    
    var body: some View {
        NavigationStack {
            
            
            ExerciseListView(workout: $viewModel.workout)
                .environment(viewModel)
                //.environment(workout2)

            
            
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

struct ExerciseListView: View {
    @Binding var workout: Workout
    var body: some View {
        List {
//            ForEach(Array(workout.supersets.enumerated()), id: \.element.id) { (index, superset) in
//                Section(header: Text("Exercise \(index + 1)" )) {
//                    ExerciseView(superset: superset)
//                }
//            }
            ForEach(workout.supersets.indices, id: \.self) { index in
                Section(header: Text("Exercise \(index + 1)")) {
                    // Create a binding to the individual superset
                    ExerciseView(superset: $workout.supersets[index])
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
    @Binding var superset: SuperSet
    
    //@State var superset: SuperSet
    var body: some View {
        HStack {
            Spacer()
            ChevronButton(isChevronTapped: $isChevronTapped)
            Spacer()
            EditButton(isEditting: $isEditting)
        }
        if isChevronTapped {
            ExpandedSupersetView(superset: superset)
        } else {
            if isEditting {
                //CollapsedSupersetEditView(collapsedSuperset: SuperSetViewModel(superset: superset).collapsedSuperset)
                CollapsedSupersetEditView(collapsedSuperset:  $superset.collapsedRepresentation)
            } else {
                //CollapsedSupersetView(collapsedSuperset: SuperSetViewModel(superset: superset).collapsedSuperset)
                CollapsedSupersetView(collapsedSuperset: superset.collapsedRepresentation)
            }
        }
    }
}

struct CollapsedSupersetView: View {
    var collapsedSuperset: CollapsedSuperset
    //var singleSet: SingleSet
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

struct CollapsedSupersetEditView: View {
    @Binding var collapsedSuperset: CollapsedSuperset
    //@Environment(WorkoutViewModel.self) private var workout2
    @Environment(WorkoutViewModel.self) private var viewModel
    
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
                    //Text("\(collapsedSuperset.numRounds)")
                    TextField("", value: $collapsedSuperset.numRounds, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                VStack {
                    Text("Rest")
                        .font(.headline)
                    //Text("\(collapsedSuperset.setRepresentation.rest.map{ "\($0)" } ?? "-")")
                    //TextField("", value: $collapsedSuperset.setRepresentation)
                    TextField("", value: $collapsedSuperset.setRepresentation.rest, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
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



struct ExpandedSupersetView: View {
    var superset: SuperSet
    var body: some View {
        ForEach(superset.sets) { set in
            ForEach(set.round) { singleset in
                SingleSetRowView(singleSet: singleset)
            }
            
            HStack {
                Spacer()
                VStack {
                    Text("Rest")
                        .font(.headline)
                    Text("\(set.rest)")
                }
                Spacer()
            }
            
        }
    }
}








#Preview {
    EditWorkoutView()
}
