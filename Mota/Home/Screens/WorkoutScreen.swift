//
//  WorkoutScreen.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI
import SwiftData


struct WorkoutScreen: View {
    
    @State var isAddSetPresented = false
    //@State var workout: Workout //= Workout(supersets: [])
    var workoutUUID: UUID
    @Environment(\.modelContext) private var context
    @Query private var workouts: [Workout]
    @State var workout: Workout = Workout(supersets: [])
    
    
    init(workoutUUID: UUID) {
        self.workoutUUID = workoutUUID
        _workouts = Query(filter: #Predicate<Workout>{$0.id == workoutUUID})
        if let firstWorkout = workouts.first {
            workout = firstWorkout
        }
    }
    
    
    var body: some View {
        NavigationStack {
            SupersetListView()
            AddSetButton{ isAddSetPresented.toggle() }
                .fullScreenCover(isPresented: $isAddSetPresented) { AddSetScreenCover() }
            .toolbar {
                ToolbarItemGroup {
                    SaveButton()
                }
            }
            .navigationTitle(workout.name)
        }
        .onAppear{
            context.insert(workout)
        }
        .environment(workout)
    }
}

struct SupersetListView: View {
    @Environment(Workout.self) var workout
    
//    @Query private var superSets: [SuperSet]
//    init() {
//        _superSets = Query(filter: #Predicate<SuperSet>{$0.workout == self.workout}, sort: \SuperSet.timestamp, order: .forward)
//    }
    
    var body: some View {
        List {
            ForEach(workout.orderedSuperSets) { superSet in
                SupersetView(superSet: superSet)
            }
            .onMove {
                workout.orderedSuperSets.move(fromOffsets: $0, toOffset: $1)
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
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationStack {
            AddExerciseView() { exercise in
                let newExerciseRound = ExerciseRound(singleSets: [SingleSet(exercise: exercise, weight: 0, reps: 0)])
                let newSuperset = SuperSet(exerciseRounds: [newExerciseRound])
                newSuperset.workout = workout
                context.insert(newSuperset)
                workout.addSuperset(newSuperset)
                dismiss()
            }
            .navigationBarItems(
                leading: Button(action: {
                    dismiss()
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
        //ToolbarItem(placement: .topBarTrailing) {
            Button("Save") {
                //Save()
            }
            .disabled(workout.supersets.count < 1)
            .padding(.trailing)
        //}
    }
}

//#Preview {
//    WorkoutScreen(workout: Workout(supersets: []))
//        .modelContainer(for: [Workout.self])
//}
