//
//  WorkoutListNewScreen.swift
//  Mota
//
//  Created by sam hastings on 15/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutListNewScreen: View {
    
//    @Query private var workouts: [WorkoutNew]
//    @Environment(\.modelContext) private var modelContext
//    @Query ( filter: #Predicate<DatabaseExercise> {
//        $0.id.localizedStandardContains("Barbell_Squat") ||
//        $0.id.localizedStandardContains("Barbell_Deadlift") ||
//        $0.id.localizedStandardContains("Barbell_Bench_Press_-_Medium_Grip") ||
//        $0.id.localizedStandardContains("Seated_Cable_Rows")
//        
//    }) var sampleExercises: [DatabaseExercise]
    
    @State private var backgroundWorkouts: [WorkoutNew] = []
    @State private var sampleBackgroundExercises: [DatabaseExercise] = []
    @Environment(\.database) private var database
    
    @State private var path = [WorkoutNew]()
    
    
    private func createBackgroundWorkouts() async -> [WorkoutNew] {
        let startCreatingModels = Date()
        var rounds = [Round]()
        for _ in 0..<2000 {
            let round = Round(singlesets: [SinglesetNew(exercise: sampleBackgroundExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleBackgroundExercises[1], weight: 90, reps: 15)])
            rounds.append(round)
        }
        let workout1 = WorkoutNew(
            name: "Legs workout",
            supersets: [
                SupersetNew(
                    rounds: rounds
                )
            ]
        )
        
        let workout2 = WorkoutNew(name: "Arms workout",
                                  supersets: [
                                    SupersetNew(
                                        rounds: [
                                            Round(singlesets: [SinglesetNew(exercise: sampleBackgroundExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleBackgroundExercises[1], weight: 90, reps: 15)])
                                        ]
                                    ),
                                    SupersetNew(
                                        rounds: [
                                            Round(singlesets: [SinglesetNew(exercise: sampleBackgroundExercises[2], weight: 10, reps: 20)]),
                                        ]
                                    )
                                  ]
        )
        print("Time to create models: \(Date().timeIntervalSince(startCreatingModels))")
        
        return [workout1, workout2]
    }
    
//    private func createSampleWorkouts() async -> [WorkoutNew] {
//        let startCreatingModels = Date()
//        var rounds = [Round]()
//        for _ in 0..<2000 {
//            let round = Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)])
//            rounds.append(round)
//        }
//        let workout1 = WorkoutNew(
//            name: "Legs workout",
//            supersets: [
//                SupersetNew(
//                    rounds: rounds
//                ),
////                SupersetNew(
////                    rounds: [
////                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[2], weight: 10, reps: 20), SinglesetNew(exercise: sampleExercises[3], weight: 40, reps: 3)]),
////                        Round(singlesets: [SinglesetNew(exercise: sampleExercises[2], weight: 10, reps: 20), SinglesetNew(exercise: sampleExercises[3], weight: 40, reps: 3)])
////                    ]
////                )
//            ]
//        )
//        
//        let workout2 = WorkoutNew(name: "Arms workout",
//                                  supersets: [
//                                    SupersetNew(
//                                        rounds: [
//                                            Round(singlesets: [SinglesetNew(exercise: sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: sampleExercises[1], weight: 90, reps: 15)])
//                                        ]
//                                    ),
//                                    SupersetNew(
//                                        rounds: [
//                                            Round(singlesets: [SinglesetNew(exercise: sampleExercises[2], weight: 10, reps: 20)]),
//                                        ]
//                                    )
//                                  ]
//        )
//        print("Time to create models: \(Date().timeIntervalSince(startCreatingModels))")
//        
//        return [workout1, workout2]
//    }
    
//    private func addSampleWorkouts() {
//        Task {
//            let workouts = await createSampleWorkouts()
//            
//            await MainActor.run {
//                let startInsertingModels = Date()
//                workouts.forEach { modelContext.insert($0) }
//                print("Time to insert models: \(Date().timeIntervalSince(startInsertingModels))")
//            }
//        }
//    }
    
    private func addBackgroundWorkouts() {
        Task {
            let workouts = await createBackgroundWorkouts()
            
            
            let startInsertingModels = Date()
            for workout in workouts {
                await database.insert(workout)
            }
            print("Time to insert models: \(Date().timeIntervalSince(startInsertingModels))")
            do {
                try await database.save()
                let descriptor = FetchDescriptor<WorkoutNew>()
                backgroundWorkouts = try await database.fetch(descriptor)
            } catch {
                print(error)
            }
        }
    }
    
//    private func removeWorkout(_ offsets: IndexSet) {
//        Task {
//            let startDeletingModels = Date()
//            for offset in offsets {
//                let workout = workouts[offset]
//                await modelContext.delete(workout) // or to delete in batches use: deleteWorkout(workout)
//            }
//            print("Time to Delete models: \(Date().timeIntervalSince(startDeletingModels))")
//        }
//    }
    
    private func removeBackgroundWorkout(_ offsets: IndexSet) {
        Task {
            let startDeletingModels = Date()
            for offset in offsets {
                let workout = backgroundWorkouts[offset]
                await database.delete(workout) // causes error
            }
            print("Time to Delete models: \(Date().timeIntervalSince(startDeletingModels))")
            do {
                try await database.save()
                let descriptor = FetchDescriptor<WorkoutNew>()
                backgroundWorkouts = try await database.fetch(descriptor) // causing error
            } catch {
                print(error)
            }
        }
    }
    
//    private func deleteWorkout(_ workout: WorkoutNew) async {
//        let batchSize = 1000
//        let roundsToDelete = workout.supersets.flatMap { $0.rounds }
//        
//        for chunk in roundsToDelete.chunked(into: batchSize) {
//            await MainActor.run {
//                for round in chunk {
//                    modelContext.delete(round)
//                }
//            }
//        }
//        
//        await MainActor.run {
//            modelContext.delete(workout)
//        }
//    }
    
    func addWorkout() {
        let newWorkout = WorkoutNew()
        //modelContext.insert(newWorkout)
        path = [newWorkout]
    }
    
    func addBackgroundWorkout() {
        Task {
            let newWorkout = WorkoutNew()
            await database.insert(newWorkout)
            try await database.save()
            path = [newWorkout]
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(backgroundWorkouts) { workout in
                    NavigationLink(value: workout) {
                        Text(workout.name)
                            .font(.headline)
                    }
                }
                .onDelete(perform: removeBackgroundWorkout)
            }
            .navigationTitle("Workout List")
            .navigationDestination(for: WorkoutNew.self) { workout in
                WorkoutNewScreen(workoutID: workout.id)
            }
            .toolbar {
                Button("Add Samples", action: addBackgroundWorkouts)
                Button("Add workout", systemImage: "plus", action: addBackgroundWorkout)
            }
        }
        .task {
            do {
                let descriptor = FetchDescriptor<WorkoutNew>()
                backgroundWorkouts = try await database.fetch(descriptor)
                sampleBackgroundExercises = try await database.fetch(FetchDescriptor<DatabaseExercise>())
            } catch {
                
            }
        }
    }
}

#Preview {
    
    struct AsyncPreviewView: View {
        @State var loadingExercises = true
        
        var body: some View {
            if loadingExercises {
                ProgressView("loading exercises")
                    .task {
                        await SharedDatabase.preview.loadExercises()
                        loadingExercises = false
                    }
            } else {
                NavigationStack{ WorkoutListNewScreen() }
            }
        }
    }
    
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        // check we haven't already added the exercises
//        let descriptor = FetchDescriptor<DatabaseExercise>()
//        let existingExercises = try container.mainContext.fetchCount(descriptor)
//        guard existingExercises == 0 else { return AsyncPreviewView().modelContainer(container) }
//        
//        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
//            fatalError("Failed to find exercises.json")
//        }
//        let data = try Data(contentsOf: url)
//        let exercises = try JSONDecoder().decode([DatabaseExercise].self, from: data)
//        for exercise in exercises {
//            container.mainContext.insert(exercise)
//        }
//        print("DATABASE created")
        
        
        return AsyncPreviewView()
            //.modelContainer(container)
            .environment(\.database, SharedDatabase.preview.database)
    } catch {
        fatalError("Failed to create model container")
    }
    
    
    
}
