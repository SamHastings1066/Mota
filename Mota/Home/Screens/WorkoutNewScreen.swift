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
    @State private var selectedExercise: DatabaseExercise?
    @State private var renameWorkout = false
    @State private var title = ""
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
                        HStack {
                            Spacer()
                            Button("", systemImage: "plus") {
                                isSelectInitialExercisePresented = true
                            }
                            Spacer()
                        }
                    }
                }
                .toolbar {
                    Menu("Edit Workout", systemImage: "ellipsis.circle") {
                        Button("Add New Set") {
                            isSelectInitialExercisePresented = true
                        }
                        Button("Reorder Sets") {
                            isReorderSupersetsPresented = true
                        }
                        Button("Rename Workout") {
                            renameWorkout.toggle()
                        }
                    }
                }
                .alert("Rename workout", isPresented: $renameWorkout) {
                    TextField("Workout Name", text: $title)
                    Button("OK", action: updateName)
                }
                .fullScreenCover(isPresented: $isSelectInitialExercisePresented,
                                 onDismiss: {
                    if selectedExercise != nil {
                        //addSuperset(with: selectedExercise)
                        addBackgroundSuperset(with: selectedExercise)
                    }
                    selectedExercise = nil
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
        .navigationTitle(title)
        .onAppear {
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
                    title = workout.name
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
    
    private func updateName() {
        workout?.name = title
    }
    
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
    
    return NavigationStack{ AsyncPreviewView() }
        .environment(\.database, SharedDatabase.preview.database)
    
}
