//
//  WorkoutScreen.swift
//  Mota
//
//  Created by sam hastings on 29/01/2024.
//

import SwiftUI
import SwiftData


struct WorkoutScreen: View {
    @Environment(\.modelContext) private var context
    
    @State var workout: Workout
    @State var isAddSetPresented = false
    
    @Query private var superSets: [SuperSet]
    init(workout: Workout) {
        self.workout = workout
        let workoutUUID = workout.id
        _superSets = Query(filter: #Predicate<SuperSet>{$0.workout?.id == workoutUUID}, sort: \SuperSet.timestamp, order: .forward)
    }
    
    private func removeSuperSet(at offsets: IndexSet) {
        for offset in offsets {
            let superSet = superSets[offset]
            context.delete(superSet)
        }
    }
    
    var body: some View {
        TextField("Workout name", text: $workout.name, axis: .vertical)
            .font(.title)
            .padding(.leading)
        List {
            ForEach(superSets) { superSet in
                SupersetView(superSet: superSet)
                    .environment(workout)
            }
            .onMove {
                    workout.orderedSuperSets.move(fromOffsets: $0, toOffset: $1)
            }
            .onDelete(perform: removeSuperSet)
        }
        AddSetButton{ isAddSetPresented.toggle() }
            .fullScreenCover(isPresented: $isAddSetPresented) {
                AddSetScreenCover()
                    .environment(workout)
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
//                if isEditting {
//                    DeleteItemButton {
//                        workout.deleteSuperset(superSet)
//                    }
//                }
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
            hideKeyboard()
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
            hideKeyboard()
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
            hideKeyboard()
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
            hideKeyboard()
            //showingAlert = true
                        withAnimation {
                            deletionClosure()
                        }
        }
//        .alert(isPresented:$showingAlert) {
//            Alert(
//                title: Text("Are you sure you want to delete this item?"),
//                primaryButton: .destructive(Text("Delete")) {
//                    withAnimation {
//                        deletionClosure()
//                    }
//                },
//                secondaryButton: .cancel()
//            )
//        }
    }
}

//#Preview {
//    WorkoutScreen(workout: Workout(supersets: []))
//        .modelContainer(for: [Workout.self])
//}
