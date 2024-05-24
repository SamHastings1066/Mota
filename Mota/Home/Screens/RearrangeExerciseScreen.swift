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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let singleset1 = SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10)
        let singleset2 = SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 100, reps: 15)
        let superset = SupersetNew(rounds: [Round(singlesets: [singleset1, singleset2]), Round(singlesets: [singleset1, singleset2])])
                            
        container.mainContext.insert(superset)
        
        
        let collapsedSuperset = CollapsedSuperset(superset: superset)
        
        return RearrangeExerciseScreen(collapsedSuperset: collapsedSuperset)
            .modelContainer(container)
    
    } catch {
        fatalError("Failed to create model container")
    }
    
}
