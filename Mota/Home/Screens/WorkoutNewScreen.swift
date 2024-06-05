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
    @State private var isReorderSupersetsPresented = false
    @State var selectedExercise: DatabaseExercise?
    //@Query var rounds: [Round]
    
    func addSuperset(with exercise: DatabaseExercise?) {
        let newRound = Round(singlesets: [SinglesetNew(exercise: selectedExercise, weight: 0, reps: 0)])
        let newSuperset = SupersetNew(rounds: [newRound])
        context.insert(newSuperset)
        workout.addSuperset(newSuperset)
    }
    
    func removeSuperset(_ superset: SupersetNew) {
        workout.deleteSuperset(superset)
    }
    
    var body: some View {
        List {
            ForEach(workout.orderedSupersets) { superset in
                SupersetNewView(superset: superset, orderedSupersets: workout.orderedSupersets) {
                    removeSuperset(superset)
                }
                    .logCreation()
            }
        }
        .navigationTitle($workout.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Menu("Edit Workout", systemImage: "ellipsis.circle") {
                Button("Add New Set") {
                    isSelectInitialExercisePresented = true
                }
                Button("Reorder Sets") {
                    isReorderSupersetsPresented = true
                }
            }
            
        }
        .fullScreenCover(isPresented: $isSelectInitialExercisePresented,
               onDismiss: {
            if selectedExercise != nil {
                addSuperset(with: selectedExercise)
            }
        },
               content: {
                SelectExerciseScreen(selectedExercise: $selectedExercise)
        })
        .sheet(isPresented: $isReorderSupersetsPresented,
               content: {
            ReorderSupersetsScreen(workout: workout)
        })
        
        //Text("Num rounds: \(rounds.count)")
//        Button("Save") {
//            do {
//                try context.save()
//            } catch {
//                print(error)
//            }
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
