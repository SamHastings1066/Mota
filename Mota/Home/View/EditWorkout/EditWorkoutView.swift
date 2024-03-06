//
//  EditWorkoutView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI


struct EditWorkoutView: View {
    
    @State var isAddExercisePresented = false
    @State var workout: Workout //= Workout()

    // TODO: remove - this is for debugging purposes
    init() {
        let set1 =  SingleSet(exercise: exercises.first(where: { $0.id == "Barbell_Squat" }) ?? exercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: exercises.first(where: { $0.id == "Bench_Press_-_Powerlifting" }) ?? exercises[0], weight: 50, reps: 6)
        let set3 = SingleSet(exercise: exercises.first(where: { $0.id == "90_90_Hamstring" }) ?? exercises[0], weight: 40, reps: 9)
        let superSet1 = SuperSet(singleSets: [set1, set2, set3], rest: 50, numRounds: 8)
        // Create second superset
        let set4 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 5)
        let set5 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let set6 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 4)
        let set7 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 40, reps: 6)
        let superSet2 = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set4, set5], rest:40), ExerciseRound(singleSets: [set6,set7], rest: 50)])
        
        self.workout = Workout(supersets: [superSet1, superSet2])
    }
    
    var body: some View {
        NavigationStack {
            ExerciseListView(workout: $workout)
                .environment(workout)
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
                    AddExerciseView(isAddExercisePresented: $isAddExercisePresented) { exercise in
                        workout.addSuperset(SuperSet(exerciseRounds: [ExerciseRound(singleSets: [SingleSet(exercise: exercise, weight: 0, reps: 0)])]))
                    }
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
    @Environment(Workout.self) var workout
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack {
            HStack {
                if isEditting {
                    DeleteItemButton {
                        workout.deleteSuperset(superSet)
                    }
                }
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
    @State var isAddExercisePresented = false
    var isEditable = true
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                ForEach( 0..<superSet.consistentExercises.count, id: \.self ) { exerciseNumber in
                    EditableSingleSetRowCollapsedView(exercise: $superSet.consistentExercises[exerciseNumber], weight: $superSet.consistentWeights[exerciseNumber], reps: $superSet.consistentReps[exerciseNumber], isEditable: isEditable
                    ) {
                        superSet.removeExercise(superSet.consistentExercises[exerciseNumber])
                    }
                }
                if isEditable {
                    HStack {
                        Spacer()
                        if superSet.consistentExercises.count > 1 {
                            Button {
                                // use .onTapGesture
                            } label: {
                                Image(systemName: "arrow.up.arrow.down.square")
                                    .imageScale(.large)
                            }
                            .onTapGesture {
                                selectedSuperSet = superSet
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "plus")
                        }
                        .onTapGesture {
                            isAddExercisePresented.toggle()
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .popover(item: $selectedSuperSet) { _ in
                        RearrangeExerceriseRoundsView(superSet: $superSet)
                    }
                    .fullScreenCover(isPresented: $isAddExercisePresented)
                    {
                        NavigationStack {
                            AddExerciseView(isAddExercisePresented: $isAddExercisePresented) { exercise in
                                superSet.addExercise(exercise)
                            }
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

struct DeleteItemButton: View {
    @State private var showingAlert = false
    var deletionClosure: () -> Void
    var body: some View {
        Button {
            //
        } label: {
            Image(systemName: "trash")
        }
        .onTapGesture {
            showingAlert = true
            //            withAnimation {
            //                deletionClosure()
            //            }
        }
        .alert(isPresented:$showingAlert) {
            Alert(
                title: Text("Are you sure you want to delete this item?"),
                primaryButton: .destructive(Text("Delete")) {
                    withAnimation {
                        deletionClosure()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    EditWorkoutView()
}


