//
//  WorkoutListScreen.swift
//  Mota
//
//  Created by sam hastings on 18/03/2024.
//

import SwiftUI
import SwiftData

struct WorkoutListScreen: View {
    @State var newWorkout: Workout?
    @Environment(\.modelContext) private var context
    @Query private var workouts: [Workout]
    
    private func removeWorkout(at offsets: IndexSet) {
        for offset in offsets {
            let workout = workouts[offset]
            context.delete(workout)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
               ForEach(workouts) { workout in
                    NavigationLink(value: workout) {
                        Text(workout.name)
                    }
                }
               .onDelete(perform: removeWorkout)
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            })
            Button {

            } label: {
                NavigationLink(value: newWorkout) {
                    Text("Create new workout")
                }
            }
            .onAppear{
                newWorkout = Workout(supersets: [])
            }
            .navigationDestination(for: Workout.self) { workout in
                    WorkoutScreen(workout: workout)
            }

        }
    }
}

#Preview {
    WorkoutListScreen()
}
