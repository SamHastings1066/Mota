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
    @Environment(\.database) private var database
    
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
                Task { try? await database.save() }
            }
        }
    }
}

#Preview {
    
    return NavigationStack {
        AsyncPreviewView(
            asyncTasks: {
                await SharedDatabase.preview.loadExercises()
                let workout =  await SharedDatabase.preview.loadDummyWorkout()
                return workout
            },
            content: { workout in
                if let workout = workout as? WorkoutNew {
                    ReorderSupersetsScreen(workout: workout)
                } else {
                    Text("No workout found.")
                }
            }
        )
    }
    .environment(\.database, SharedDatabase.preview.database)
}
