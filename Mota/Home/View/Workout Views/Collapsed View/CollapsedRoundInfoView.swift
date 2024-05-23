//
//  CollapsedRoundInfoView.swift
//  Mota
//
//  Created by sam hastings on 19/04/2024.
//

import SwiftUI
import SwiftData

struct CollapsedRoundInfoView: View {
    @Binding var collapsedSuperset: CollapsedSuperset
    var body: some View {
        VStack(alignment: .center){
            VStack {
                Text("Rounds")
                    .font(.headline)

                    TextField("", value: $collapsedSuperset.numRounds, formatter: NumberFormatter())
                        .fixedSize()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
 
            }
            
            VStack {
                Text("Rest")
                    .font(.headline)

                    TextField("", value: $collapsedSuperset.rest, formatter: NumberFormatter())
                        .fixedSize()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)

            }
        }
        .padding(.all, 10)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let superset1 = SupersetNew(
            rounds: [
                Round(
                    singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)],
                    rest:  60
                ),
                Round(
                    singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 90, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)],
                    rest:  60
                )
            ]
        )
        let collapsedSuperset1 = CollapsedSuperset(superset: superset1)
        
        container.mainContext.insert(superset1)
        
        return CollapsedRoundInfoView(collapsedSuperset: .constant(collapsedSuperset1))
    } catch {
        fatalError("Failed to create model container")
    }
    
}
