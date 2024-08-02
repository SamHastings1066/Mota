//
//  CompletedWorkoutsForDayScreen.swift
//  Mota
//
//  Created by sam hastings on 31/07/2024.
//

import SwiftUI

struct CompletedWorkoutsForDayScreen: View {
    @Environment(\.database) private var database
    @State var workoutsCompleted: [WorkoutCompleted]
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
    
    private func removeWorkout(_ offsets: IndexSet) {
        Task {
            let startDeletingModels = Date()
            for offset in offsets {
                let workout = workoutsCompleted[offset]
                await database.delete(workout) // causes error
                workoutsCompleted.remove(at: offset)
            }
            print("Time to Delete models: \(Date().timeIntervalSince(startDeletingModels))")
            try? await database.save()
        }
    }
    
    var body: some View {
        if workoutsCompleted.isEmpty {
            Text("No workouts")
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(date != nil ? "Workouts on \(formattedDate)" : "No date found")
        } else {
            List{
                ForEach(workoutsCompleted) { workout in
                    let stats = workout.computeWorkoutStats()
                    VStack(alignment:.leading) {
                        Text(workout.name)
                            .font(.headline)
                        Text("Total reps: \(stats.totalReps)")
                        Text("Total volume: \(stats.totalVolume) kgs")
                        Text("Excerises: \(stats.uniqueExercises.joined(separator: ", "))")
                        PieChartView(musclesUsed: stats.musclesUsed, maxMuscles: 3)
                    }
                }
                .onDelete(perform: removeWorkout)
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
                print(workout!.computeWorkoutStats().musclesUsed)
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
