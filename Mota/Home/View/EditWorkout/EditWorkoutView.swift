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
            SupersetListView()
            AddSetButton{ isAddSetPresented.toggle() }
                .fullScreenCover(isPresented: $isAddSetPresented) { AddSetScreenCover{isAddSetPresented.toggle()} }
            .toolbar {
                ToolbarItemGroup {
                    SaveButton()
                }
            }
            .navigationTitle("New Workout")
        }
        .environment(workout)
    }
}

struct SupersetListView: View {
    @Environment(Workout.self) var workout
    var body: some View {
        List {
            ForEach(workout.supersets) { superSet in
                SupersetView(superSet: superSet)
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
    @Bindable var superSet: SuperSet
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
                ChevronButton(isChevronTapped: isExpanded) {isExpanded.toggle()}
                Spacer()
                EditButtonBespoke(isEditting: isEditting) {isEditting.toggle()}
            }
            if isExpanded {
                ExpandedSupersetEditView(superSet: superSet, isEditable: isEditting)
            } else {
                CollapsedSupersetEditView(superSet: superSet, isEditable: isEditting)
            }
        }
        
    }
}

struct AddSetScreenCover: View {
    @Environment(Workout.self) var workout: Workout
    var cancelAction: () -> Void
    var body: some View {
        NavigationStack {
            AddExerciseView() { exercise in
                workout.addSuperset(SuperSet(exerciseRounds: [ExerciseRound(singleSets: [SingleSet(exercise: exercise, weight: 0, reps: 0)])]))
                cancelAction()
            }
            .navigationBarItems(
                leading: Button(action: {
                    cancelAction()
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
    var buttonAction: () -> Void
    var body: some View {
        Button {
            buttonAction()
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
    var isChevronTapped: Bool
    var buttonAction: () -> Void
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
                buttonAction()
            }
        }
    }
}

struct EditButtonBespoke: View {
    var isEditting: Bool
    var buttonAction: () -> Void
    var body: some View {
        Button(action: {
            // leave blank and use .onTapGesture to allow both buttons to function within the same Hstack
        }) {
            Text( isEditting ? "Done" : "Edit")
        }
        .onTapGesture {
            withAnimation{
                buttonAction()
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

struct SaveButton: View {
    @Environment(Workout.self) var workout
    var body: some View {
        Button {
        } label: {
            Text("Save")
        }
        .disabled(workout.supersets.count < 1)
        .padding(.trailing)
    }
}

#Preview {
    EditWorkoutView()
}
