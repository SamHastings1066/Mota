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
                    .navigationTitle(title)
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
                    .padding()
                }
            } else {
                Text("Workout not found")
            }
        //}
        //.navigationTitle(title)
//        .onAppear {
//            loadWorkout()
//        }
        
    }
    
    private func loadWorkout() {
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
        Task {
            workout?.name = title
            try? await database.save()
        }
    }
    
    func addSuperset(with exercise: DatabaseExercise?) {
        let newRound = Round(singlesets: [SinglesetNew(exercise: selectedExercise, weight: 0, reps: 0)])
        let newSuperset = SupersetNew(rounds: [newRound])
        Task {
            await database.insert(newSuperset)
            workout?.addSuperset(newSuperset) 
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
