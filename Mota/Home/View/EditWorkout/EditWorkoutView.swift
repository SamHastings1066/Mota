//
//  EditWorkoutView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI


struct EditWorkoutView: View {
    
    @State var isAddExercisePresented = false
    @State var viewModel = WorkoutViewModel()
    
    var body: some View {
        NavigationStack {
            ExerciseListView(workout: $viewModel.workout)
            Button {
                isAddExercisePresented.toggle()
            } label: {
                HStack{
                    Image(systemName: "plus.circle.fill")
                    Text("Add set")
                }
            }
            .fullScreenCover(isPresented: $isAddExercisePresented)
            {
                NavigationStack {
                    AddExerciseView(workout: $viewModel.workout, isAddExercisePresented: $isAddExercisePresented)
                        .navigationBarItems(
                            leading: Button(action: {
                                isAddExercisePresented.toggle()
                            }) {
                                Text("Cancel")
                            }
                            
                        )
                }
                .navigationBarTitle("Add Exercise", displayMode: .inline)
            }
            .navigationTitle("New Workout")
        }
    }
}

struct ExerciseListView: View {
    @Binding var workout: Workout
    var body: some View {
        List {
            ForEach($workout.supersets) { $superSet in
                ExerciseView(superSet: $superSet)
            }
            .onMove {
                workout.supersets.move(fromOffsets: $0, toOffset: $1)
            }
        }
    }
}

struct ExerciseView: View {
    @State private var isExpanded = false
    @State private var isEditting = false
    @Binding var superSet: SuperSet
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ChevronButton(isChevronTapped: $isExpanded)
                Spacer()
                EditButtonBespoke(isEditting: $isEditting)
            }
            if isExpanded {
                ExpandedSupersetEditView(superSet: $superSet, isEditable: isEditting, isExpanded: isExpanded)
            } else {
                CollapsedSupersetEditView(superSet: $superSet, isEditable: isEditting)
            }
        }
        
    }
}

struct CollapsedSupersetEditView: View {
    
    @Binding var superSet: SuperSet
    @State var selectedSuperSet: SuperSet?
    var isEditable = true
    
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
                        TextField("", value: $superSet.consistentRest, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else {
                        Text("\(superSet.consistentRest.map{ "\($0)" } ?? "-")")
                    }
                }
                if isEditable {
                    Button {
                        selectedSuperSet = superSet
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.square")
                            .imageScale(.large)
                    }
                    .padding(.top, 10)
                    .popover(item: $selectedSuperSet) { _ in
                        RearrangeExerceriseRoundsView(superSet: $superSet)
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

struct EditButtonBespoke: View {
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
