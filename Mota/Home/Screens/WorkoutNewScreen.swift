//
//  WorkoutNewScreen.swift
//  Mota
//
//  Created by sam hastings on 16/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutNewScreen: View {
    
    //@Environment(\.modelContext) private var context
    @State private var workout: WorkoutNew?
    @State private var isLoading = true
    @State private var isSelectInitialExercisePresented = false
    @State private var isReorderSupersetsPresented = false
    @State var selectedExercise: DatabaseExercise?
    
    @Environment(\.database) private var database
    
    let workoutID: UUID

    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Retrieving workout information")
            } else if let workout {
                List {
                    if workout.supersets.isEmpty {
                        Button("Add set") {
                            isSelectInitialExercisePresented = true
                        }
                    }
                    else {
                        ForEach(workout.orderedSupersets) { superset in
                            SupersetNewView(superset: superset, orderedSupersets: workout.orderedSupersets) {
                                removeSuperset(superset)
                            }
                            //.logCreation()
                        }
                    }
                }
//                .navigationTitle($workout.name)
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
                        //addSuperset(with: selectedExercise)
                        addBackgroundSuperset(with: selectedExercise)
                    }
                },
                                 content: {
                    SelectExerciseScreen(selectedExercise: $selectedExercise)
                })
                .sheet(isPresented: $isReorderSupersetsPresented,
                       content: {
                    ReorderSupersetsScreen(workout: workout)
                })
            } else {
                Text("Workout not found")
            }
        }
        .onAppear {
            //loadWorkout()
            loadBackgroundWorkout()
        }
        
    }
    
    private func loadBackgroundWorkout() {
        isLoading = true
        Task {
            let start = Date()
            let descriptor = FetchDescriptor<WorkoutNew>(
                predicate: #Predicate { $0.id == workoutID }
            )
            let workouts: [WorkoutNew]? = try? await database.fetch(descriptor)
            print("Fetch takes \(Date().timeIntervalSince(start))")
            if let workout = workouts?.first {
                self.workout = workout
                await MainActor.run {
                    self.isLoading = false
                }
            }
            else {
                print("cannot load workout")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
        
    }
    
//    private func loadWorkout() {
//        Task {
//            //if let workout = await fetchWorkout() {
//            let backgroundActor = BackgroundSerialPersistenceActor(modelContainer: context.container)
//            let start = Date()
//            let workouts = try? await backgroundActor.fetchData(predicate: #Predicate {return $0.id == workoutID} ) as [WorkoutNew]
//            print("Fetch takes \(Date().timeIntervalSince(start))")
//            if let workout = workouts?.first {
//                self.workout = workout
//                //try? await Task.sleep(nanoseconds: 3_000_000_000) // This line ensures the function suspends and resigns control of the main threda to allow it to process user interactions.
//                await MainActor.run {
//                    self.isLoading = false
//                }
//            }             
//            else {
//                print("cannot load workout")
//                await MainActor.run {
//                    self.isLoading = false
//                }
//            }
//        }
//    }
    
    
//    func addSuperset(with exercise: DatabaseExercise?) {
//        let newRound = Round(singlesets: [SinglesetNew(exercise: selectedExercise, weight: 0, reps: 0)])
//        let newSuperset = SupersetNew(rounds: [newRound])
//        context.insert(newSuperset)
//        workout?.addSuperset(newSuperset) // This line causing the issue
//    }
    
    func addBackgroundSuperset(with exercise: DatabaseExercise?) {
        let newRound = Round(singlesets: [SinglesetNew(exercise: selectedExercise, weight: 0, reps: 0)])
        let newSuperset = SupersetNew(rounds: [newRound])
        Task {
            await database.insert(newSuperset)
            try? await database.save()
            workout?.addSuperset(newSuperset) 
        }
    }
    
    func removeSuperset(_ superset: SupersetNew) {
        workout?.deleteSuperset(superset)
    }
}

#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
//        
//        let emptyWorkout = WorkoutNew(name: "Empty workout")
//        let armsWorkout = WorkoutNew(name: "Arms workout",
//                                  supersets: [
//                                    SupersetNew(
//                                        rounds: [
//                                            Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)])
//                                        ]
//                                    ),
//                                    SupersetNew(
//                                        rounds: [
//                                            Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[2], weight: 10, reps: 20)]),
//                                        ]
//                                    )
//                                  ]
//        )
//        
//        container.mainContext.insert(armsWorkout)
//        
//        return NavigationStack {
//            WorkoutNewScreen(workoutID: armsWorkout.id)
//                .modelContainer(container)
//        }
//    } catch {
//        fatalError("Failed to create model container")
//    }
    
    struct AsyncPreviewView: View {
        @State var loadingExercises = true
        @State var workoutID: UUID?
        
        var body: some View {
            if loadingExercises {
                ProgressView("loading exercises")
                    .task {
                        await SharedDatabase.preview.loadExercises()
                        workoutID = await SharedDatabase.preview.loadDummyWorkout()
                        loadingExercises = false
                    }
            } else {
                if let workoutID {
                    WorkoutNewScreen(workoutID: workoutID)
                } else {
                    Text("No workout found.")
                }
            }
        }
    }
    
    return AsyncPreviewView()
        .environment(\.database, SharedDatabase.preview.database)
    
}
