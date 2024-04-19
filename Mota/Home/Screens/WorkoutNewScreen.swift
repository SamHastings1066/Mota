//
//  WorkoutNewScreen.swift
//  Mota
//
//  Created by sam hastings on 16/04/2024.
//

import SwiftUI
import SwiftData

struct WorkoutNewScreen: View {
    
    @Bindable var workout: WorkoutNew
    
    var body: some View {
        List {
            ForEach(workout.orderedSupersets) { superset in
                SupersetNewView(superset: superset, orderedSupersets: workout.orderedSupersets)
            }
        }

            .navigationTitle(workout.name)
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: WorkoutNew.self, SuperSet.self, configurations: config)
//        
//        let workout1 = WorkoutNew(
//            name: "Legs workout",
//            supersets: [
//                SupersetNew(name: "Squats"),
//                SupersetNew(name: "Deadlifts")
//            ]
//        )
//        
//        return WorkoutNewScreen(workout: workout1)
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
//}
