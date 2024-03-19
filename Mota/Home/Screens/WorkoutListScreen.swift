//
//  WorkoutListScreen.swift
//  Mota
//
//  Created by sam hastings on 18/03/2024.
//

import SwiftUI

struct WorkoutListScreen: View {
    @State var selectedWorkout: Workout?
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Button("Create workout") {
            selectedWorkout = Workout(supersets: [])
            if let selectedWorkout {
                context.insert(selectedWorkout)
            }
        }
        .fullScreenCover(item: $selectedWorkout) { workout in
            WorkoutScreen(workout: workout)
        }
    }
}

#Preview {
    WorkoutListScreen()
}
