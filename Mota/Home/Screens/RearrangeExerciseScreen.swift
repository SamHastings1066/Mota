//
//  RearrangeExerciseScreen.swift
//  Mota
//
//  Created by sam hastings on 24/05/2024.
//

import SwiftUI
import SwiftData

struct RearrangeExerciseScreen: View {
    var collapsedSuperset: CollapsedSuperset
    
    var body: some View {
        
        List {
                ForEach(collapsedSuperset.exercises) { exercise in
                    ExerciseRowView(exercise: exercise)
                }
                .onMove {
                    collapsedSuperset.exercises.move(fromOffsets: $0, toOffset: $1)
                }
        }
    }
}

#Preview {
    
    return AsyncPreviewView(
        asyncTasks: {
            await SharedDatabase.preview.loadExercises()
            return await SharedDatabase.preview.loadDummyWorkoutTemplate()
        },
        content: { workout in
            if let workout = workout as? WorkoutTemplate {
                let superset = workout.orderedSupersets[0]
                RearrangeExerciseScreen(collapsedSuperset: CollapsedSuperset(superset: superset))
            } else {
                Text("No superset found.")
            }
        }
    )
    .environment(\.database, SharedDatabase.preview.database)
}
