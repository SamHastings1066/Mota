//
//  CompletedWorkoutsForDayScreen.swift
//  Mota
//
//  Created by sam hastings on 31/07/2024.
//

import SwiftUI

struct CompletedWorkoutsForDayScreen: View {
    var workoutsCompleted: [WorkoutCompleted]
    var body: some View {
        Text("#workouts: \(workoutsCompleted.count)")
    }
}

#Preview {
        AsyncPreviewView(
            asyncTasks: {
                await SharedDatabase.preview.loadExercises()
                let workout =  await SharedDatabase.preview.loadDummyWorkoutTemplate()
                return workout
            },
            content: { workout in
                if let workout = workout {
                    let workoutsCompleted = [WorkoutCompleted(workout: workout)]
                    CompletedWorkoutsForDayScreen(workoutsCompleted: workoutsCompleted)
                } else {
                    Text("No workout found.")
                }
            }
        )
    .environment(\.database, SharedDatabase.preview.database)
}
