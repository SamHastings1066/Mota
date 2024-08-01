//
//  CompletedWorkoutsForDayScreen.swift
//  Mota
//
//  Created by sam hastings on 31/07/2024.
//

import SwiftUI

struct CompletedWorkoutsForDayScreen: View {
    var workoutsCompleted: [WorkoutCompleted]
    var date: Date?
    
    private var formattedDate: String {
        if let date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        } else {
            return "No date found"
        }
    }
    
    var body: some View {
        if workoutsCompleted.isEmpty {
            Text("No workouts")
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(date != nil ? "Workouts on \(formattedDate)" : "No date found")
        } else {
            List(workoutsCompleted) { workout in
                VStack(alignment:.leading) {
                    Text(workout.name)
                    Text("Total reps: \(workout.computeTotalReps())")
                    Text("Total volume: \(workout.computeTotalVolume()) kgs")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(date != nil ? "Workouts on \(formattedDate)" : "No date found")
        }
        
    }
}

#Preview {
        NavigationStack {
            AsyncPreviewView(
                asyncTasks: {
                    await SharedDatabase.preview.loadExercises()
                    let workout =  await SharedDatabase.preview.loadDummyCompletedWorkout()
                    return workout
                },
                content: { workout in
                    if let workout = workout as? WorkoutCompleted {
                        CompletedWorkoutsForDayScreen(workoutsCompleted: [workout], date: Date())
                    } else {
                        Text("No workout found.")
                    }
                }
            )
        }
    .environment(\.database, SharedDatabase.preview.database)
}
