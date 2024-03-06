//
//  ExpandedSupersetEditView.swift
//  Mota
//
//  Created by sam hastings on 06/03/2024.
//

import SwiftUI

struct ExpandedSupersetEditView: View {
    @Binding var superSet: SuperSet
    var isEditable = true
    var isExpanded = false
    var body: some View {
        ForEach( 0..<superSet.numRounds, id: \.self ) { roundNumber in
            ForEach( 0..<superSet.exerciseRounds[roundNumber].singleSets.count, id: \.self ) { exerciseNumber in
                EditableSingleSetRowView(exercise: $superSet.exerciseRounds[roundNumber].singleSets[exerciseNumber].exercise, weight: $superSet.exerciseRounds[roundNumber].singleSets[exerciseNumber].weight, reps: $superSet.exerciseRounds[roundNumber].singleSets[exerciseNumber].reps,
                                         isEditable: isEditable, isExpanded: isExpanded
                )
            }
            HStack {
                Spacer()
                VStack {
                    Text("Rest")
                        .font(.headline)
                    if isEditable {
                        TextField("", value: $superSet.exerciseRounds[roundNumber].rest, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    } else {
                        Text("\(superSet.exerciseRounds[roundNumber].rest.map{ "\($0)" } ?? "-")")
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    Group {
        ExpandedSupersetEditView(superSet: .constant(SuperSet(singleSets: [SingleSet(exercise: exercises[0], weight: 50, reps: 5)], rest: 60, numRounds: 2)), isEditable: false)
        Text("Edit mode:")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        ExpandedSupersetEditView(superSet: .constant(SuperSet(singleSets: [SingleSet(exercise: exercises[0], weight: 50, reps: 5)], rest: 60, numRounds: 2)))
    }
}