//
//  WorkoutNewScreen.swift
//  Mota
//
//  Created by sam hastings on 16/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutNewScreen: View {
    
    @State private var workout: WorkoutTemplate?
    @State private var isLoading = true
    @State private var isSelectInitialExercisePresented = false
    @State private var isReorderSupersetsPresented = false
    @State private var selectedExercise: DatabaseExercise?
    @State private var addToLog = false
    @Binding var renameWorkout: Bool
    @State private var title = ""
    @Environment(\.database) private var database
    
    let workoutID: UUID

    var body: some View {
        //Group {
            if isLoading {
                ProgressView("Retrieving workout information")
                    .onAppear {
                        loadWorkout()
                    }
            } else if let workout {
                ZStack(alignment: .bottom) {
                    List {
                        
                        ForEach(workout.orderedSupersets) { superset in
                            SupersetNewView(superset: superset, orderedSupersets: workout.orderedSupersets) {
                                removeSuperset(superset)
                            }
                        }
                        .onMove {
                            workout.orderedSupersets.move(fromOffsets: $0, toOffset: $1)
                            Task { try? await database.save() }
                        }
                        .onDelete { indexSet in
                            for offset in indexSet {
                                let superset = workout.orderedSupersets[offset]
                                removeSuperset(superset)
                            }
                        }
                    }
                    .navigationTitle(workout.name)
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
                    .alert("Add to log", isPresented: $addToLog) {
                        Button("OK", action: addWorkoutToLog)
                        Button("Cancel", role: .cancel, action: {})
                    } message: {
                        Text("This will add the workout to your workout log.")
                    }
                    .fullScreenCover(isPresented: $isSelectInitialExercisePresented,
                                     onDismiss: {
                        if selectedExercise != nil {
                            addSuperset(with: selectedExercise)
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
                    HStack {
                        Button {
                            isSelectInitialExercisePresented = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline.weight(.semibold))
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4, x: 0, y: 4)
                        }
                        Button {
                            addToLog = true
                        } label: {
                            Text("Add to log")
                                .font(.headline.weight(.semibold))
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                .shadow(radius: 4, x: 0, y: 4)
                        }
                    //.padding()
                    }
                    .padding()
                }
            } else {
                Text("Workout not found")
            }
        //}
        //.navigationTitle(title)
        
    }
    
    private func loadWorkout() {
        isLoading = true
        Task {
            let start = Date()
            let descriptor = FetchDescriptor<WorkoutTemplate>(
                predicate: #Predicate { $0.id == workoutID }
            )
            let workouts: [WorkoutTemplate]? = try? await database.fetch(descriptor)
            //print("Fetch takes \(Date().timeIntervalSince(start))")
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
        Task {
            try? await database.save()
        }
    }
    
    private func addWorkoutToLog() {
        if let workout {
            let completedWorkout = WorkoutCompleted(workout: workout)
            Task {
                await database.insert(completedWorkout)
                try? await database.save()
            }
        }
    }
    
    func addSuperset(with exercise: DatabaseExercise?) {
        let newRound = Round(singlesets: [SinglesetNew(exercise: selectedExercise, weight: 0, reps: 0)])
        let newSuperset = SupersetNew(rounds: [newRound])
        workout?.addSuperset(newSuperset)
        Task {
            await database.insert(newSuperset)
            try? await database.save()
        }
    }
    
    func removeSuperset(_ superset: SupersetNew) {
        workout?.deleteSuperset(superset)
        Task {
            try? await database.save()
        }
    }
}

#Preview {
    
    return NavigationStack {
        AsyncPreviewView(
            asyncTasks: {
                await SharedDatabase.preview.loadExercises()
                let workout =  await SharedDatabase.preview.loadDummyWorkoutTemplate()
                return workout
            },
            content: { workout in
                if let workout = workout as? WorkoutTemplate {
                    WorkoutNewScreen(renameWorkout: .constant(false), workoutID: workout.id)
                } else {
                    Text("No workout found.")
                }
            }
        )
    }
    .environment(\.database, SharedDatabase.preview.database)
    
    
}
