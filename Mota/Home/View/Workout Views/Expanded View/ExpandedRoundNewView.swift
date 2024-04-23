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
        }
        RestNewView(rest: $round.rest, isEditable: $isEditable)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let round = Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)])
        
        container.mainContext.insert(round)
        
        return ExpandedRoundNewView(round: round, isEditable: .constant(false))
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
