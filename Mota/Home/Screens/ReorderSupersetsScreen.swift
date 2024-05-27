//
//  ReorderSupersetsScreen.swift
//  Mota
//
//  Created by sam hastings on 27/05/2024.
//

import SwiftUI
import SwiftData

struct ReorderSupersetsScreen: View {
    @Bindable var workout: WorkoutNew
    var body: some View {
        Text("Drag and drop to reorder Sets")
        List {
            ForEach(workout.orderedSupersets) { superset in
                VStack {
                    Text("Set")
                    ForEach(CollapsedSuperset(superset: superset).exercises) { exercise in
                        ExerciseRowView(exercise: exercise)
                    }
                }
            }
            .onMove{
                workout.orderedSupersets.move(fromOffsets: $0, toOffset: $1)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let workout = WorkoutNew(name: "Arms workout",
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
        
        container.mainContext.insert(workout)
        
        return NavigationStack {
            ReorderSupersetsScreen(workout: workout)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
    
}
