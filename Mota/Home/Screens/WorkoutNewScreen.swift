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
    //@Bindable var workout: WorkoutNew
    @State private var workout: WorkoutNew?
    @State private var isLoading = true
    @State private var isSelectInitialExercisePresented = false
    @State private var isReorderSupersetsPresented = false
    @State var selectedExercise: DatabaseExercise?
    @Query private var workouts: [WorkoutNew]
    
    let workoutID: UUID
    
    mutating func retrieveWorkout() async {
        _workouts = await Query(
            filter: #Predicate {
                return $0.id == workoutID
            }
        )
        self.isLoading = false
    }
    
    init(workoutID: UUID) {
        self.workoutID = workoutID
        _workouts = Query(
            filter: #Predicate {
                return $0.id == workoutID
            }
        )
        print("workout ID: \(workoutID)")
        print("workout count Initializer: \(workouts.count)")
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Retrieving workout information")
            } else if let workout = workout {
                List {
                    ForEach(workout.orderedSupersets) { superset in
                        SupersetNewView(superset: superset, orderedSupersets: workout.orderedSupersets) {
                            removeSuperset(superset)
                        }
                        .logCreation()
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
            } else {
                Text("Workout not found")
            }
        }
        .onAppear {
            loadWorkout()
        }
        
    }
    
    private func loadWorkout() {
        Task {
            if let workout = await fetchWorkout() {
                await MainActor.run {
                    self.workout = workout
                    self.isLoading = false
                }
            }             
            else {
                print("cannot load workout")
                self.isLoading = false
            }
        }
    }
    
    private func fetchWorkout() async -> WorkoutNew? {
        // Simulate a delay for demonstration purposes
        //try? await Task.sleep(nanoseconds: 3_000_000_000)
        return workouts.first
    }
    
    func addSuperset(with exercise: DatabaseExercise?) {
        let newRound = Round(singlesets: [SinglesetNew(exercise: selectedExercise, weight: 0, reps: 0)])
        let newSuperset = SupersetNew(rounds: [newRound])
        context.insert(newSuperset)
        workout?.addSuperset(newSuperset)
    }
    
    func removeSuperset(_ superset: SupersetNew) {
        workout?.deleteSuperset(superset)
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
            WorkoutNewScreen(workoutID: workout2.id)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
