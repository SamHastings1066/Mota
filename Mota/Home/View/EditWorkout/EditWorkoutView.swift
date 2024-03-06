//
//  EditWorkoutView.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI


struct EditWorkoutView: View {
    
    @State var isAddSetPresented = false
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
            SupersetListView(workout: $workout)
                .environment(workout)
            AddSetButton(isAddSetPresented: $isAddSetPresented)
            .fullScreenCover(isPresented: $isAddSetPresented) { AddSetScreenCover(workout: workout, isAddSetPresented: $isAddSetPresented) }
            .navigationTitle("New Workout")
        }
    }
}

struct SupersetListView: View {
    @Binding var workout: Workout
    var body: some View {
        List {
            ForEach($workout.supersets) { $superSet in
                SupersetView(superSet: $superSet)
            }
            .onMove {
                workout.supersets.move(fromOffsets: $0, toOffset: $1)
            }
        }
    }
}

struct SupersetView: View {
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

struct AddSetScreenCover: View {
    var workout: Workout
    @Binding var isAddSetPresented: Bool
    var body: some View {
        NavigationStack {
            AddExerciseView(isAddExercisePresented: $isAddSetPresented) { exercise in
                workout.addSuperset(SuperSet(exerciseRounds: [ExerciseRound(singleSets: [SingleSet(exercise: exercise, weight: 0, reps: 0)])]))
            }
            .navigationBarItems(
                leading: Button(action: {
                    isAddSetPresented.toggle()
                }) {
                    Text("Cancel")
                }
            )
        }
        .navigationBarTitle("Add Exercise", displayMode: .inline)
    }
}

// MARK: - Buttons

struct AddSetButton: View {
    @Binding var isAddSetPresented: Bool
    var body: some View {
        Button {
            isAddSetPresented.toggle()
        } label: {
            HStack{
                Image(systemName: "plus.circle.fill")
                Text("Add set")
            }
        }
        .padding([.bottom, .top])
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




