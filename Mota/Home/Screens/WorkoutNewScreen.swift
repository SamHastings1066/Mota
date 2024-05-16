//
//  WorkoutNewScreen.swift
//  Mota
//
//  Created by sam hastings on 16/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutNewScreen: View {
    
    @Environment(\.modelContext) private var context
    @Bindable var workout: WorkoutNew
    @State private var isSelectInitialExercisePresented = false
    @State var dummyExercise: DatabaseExercise?
//    @State var collapsedSupersetToEdit: CollapsedSuperset? = nil
    
    func addSuperSet() {
        let newRound = Round(singlesets: [SinglesetNew(exercise: nil, weight: 0, reps: 0)])
        let newSuperset = SupersetNew(rounds: [newRound])
        context.insert(newSuperset)
        workout.addSuperset(newSuperset)
        isSelectInitialExercisePresented = true
//        collapsedSupersetToEdit = CollapsedSuperset(superset: newSuperset)
    }
    
    var body: some View {
        List {
            ForEach(workout.orderedSupersets) { superset in
                SupersetNewView(superset: superset, orderedSupersets: workout.orderedSupersets)
            }
        }
        .navigationTitle(workout.name)
        .toolbar{
            Button("Add superset", systemImage: "plus", action: addSuperSet)
        }
//        .fullScreenCover(isPresented: $isSelectInitialExercisePresented) {
//            AddSetScreenCover()
//                .environment(workout)
//        }
        .popover(isPresented: $isSelectInitialExercisePresented, content: {
            SelectExerciseScreen(selectedExercise: $dummyExercise)
        })
//        .popover(item: $collapsedSupersetToEdit) { collapsedSuperset in
//            EditSupersetScreen(collapsedSuperset: collapsedSuperset)
//        }
            
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let workout2 = WorkoutNew(name: "Arms workout",
            supersets: [
                SupersetNew(
                    rounds: [
                        Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)])
                    ]
                ),
                SupersetNew(
                    rounds: [
                        Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[2], weight: 10, reps: 20)]),
                    ]
                )
            ]
        )
        
        container.mainContext.insert(workout2)
        
        return NavigationStack {
            WorkoutNewScreen(workout: workout2)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
