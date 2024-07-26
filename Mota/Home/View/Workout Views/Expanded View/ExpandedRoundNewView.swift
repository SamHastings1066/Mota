//
//  ExpandedRoundNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI
import SwiftData

struct ExpandedRoundNewView: View {
    
    @Bindable var round: Round
    @Binding var isEditable: Bool
    
    var body: some View {
        ForEach(round.orderedSinglesets) { singleset in
            ExpandedSinglesetNewView(singleset: singleset)
                .logCreation()
        }
        RestNewView(rest: $round.rest, isEditable: $isEditable)
            .logCreation()
    }
}

#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
//        
//        let round = Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)])
//        
//        container.mainContext.insert(round)
//        
//        return ExpandedRoundNewView(round: round, isEditable: .constant(false))
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
    return NavigationStack {
        AsyncPreviewView(
            asyncTasks: {
                await SharedDatabase.preview.loadExercises()
                let workout =  await SharedDatabase.preview.loadDummyWorkout()
                return workout
            },
            content: { workout in
                if let workout = workout as? WorkoutNew {
                    let round = workout.orderedSupersets[0].orderedRounds[0]
                    ExpandedRoundNewView(round: round, isEditable: .constant(false))
                } else {
                    Text("No workout found.")
                }
            }
        )
    }
    .environment(\.database, SharedDatabase.preview.database)
}
