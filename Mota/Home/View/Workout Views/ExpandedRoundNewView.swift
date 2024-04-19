//
//  ExpandedRoundNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI

struct ExpandedRoundNewView: View {
    
    @Bindable var round: Round
    
    var body: some View {
        ForEach(round.orderedSinglesets) { singleset in
            ExpandedSinglesetNewView(singleset: singleset)
        }
        RestNewView(rest: $round.rest)
    }
}

#Preview {
    ExpandedRoundNewView(
        round: Round(
            singlesets: [
                SinglesetNew(exercise: DatabaseExercise.sampleExercises[2], weight: 10, reps: 20)
            ]
        )
    )
}
