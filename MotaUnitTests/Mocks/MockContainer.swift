//
//  MockContainer.swift
//  Mota
//
//  Created by sam hastings on 13/03/2024.
//

import Foundation
import SwiftData

@MainActor
var mockContainer: ModelContainer {
    do {
        let container = try ModelContainer(for: Workout.self, SuperSet.self, ExerciseRound.self, SingleSet.self, DatabaseExercise.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        print("returning a new container")
        return container
    } catch {
        fatalError("Failed to create container")
    }
}
