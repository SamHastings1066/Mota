//
//  CollapsedRoundInfoView.swift
//  Mota
//
//  Created by sam hastings on 19/04/2024.
//

import SwiftUI
import SwiftData

// TODO: don't bind the Rounds TextField directly to the collapsedSuperset.numRounds
// instead, use another state object `numRounds` which is initialised to the value of the collapsedSuperset.numRounds, and when numRounds is reduced it deletes the excess rounds in collapsedsuperset.superset.orderedrounds from the model context and

struct CollapsedRoundInfoView: View {
    //@Environment(\.modelContext) private var context
    @Environment(\.database) private var database
    @Binding var collapsedSuperset: CollapsedSuperset
    @FocusState var isNumRoundsFocused: Bool
    @FocusState var isRestFocused: Bool
    
    @State private var numRounds: Int = 1
    @State private var rest: Int = 0
    
    private func updateNumRounds() {
        if numRounds > collapsedSuperset.numRounds {
            collapsedSuperset.numRounds = numRounds
        } else if numRounds < collapsedSuperset.numRounds {
            let excessRounds = collapsedSuperset.superset.orderedRounds[numRounds..<collapsedSuperset.superset.orderedRounds.count]
            collapsedSuperset.numRounds = numRounds
            for excessRound in excessRounds {
                Task {
                    await database.delete(excessRound)
                }
            }
        }
        Task { try? await database.save() }
    }
    
    private func updateRest() {
        collapsedSuperset.rest = rest
        Task { try? await database.save() }
    }
    
    var body: some View {
        VStack(alignment: .center){
            VStack {
                Text("Rounds")
                    .font(.headline)
                
                //TextField("", value: $collapsedSuperset.numRounds, formatter: NumberFormatter())
                TextField("", value: $numRounds, formatter: NumberFormatter())
                    .focused($isNumRoundsFocused)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
            }
            .onAppear{
                Task {
                    numRounds = await collapsedSuperset.getNumRounds()
                    rest = await collapsedSuperset.getRest()
                }
            }
            .onChange(of: isNumRoundsFocused) { oldValue, newValue in
                if oldValue == true && newValue == false{
                    updateNumRounds()
                }
            }
            .onChange(of: isRestFocused) { oldValue, newValue in
                if oldValue == true && newValue == false{
                    updateRest()
                }
            }
            
            VStack {
                Text("Rest")
                    .font(.headline)
                
                TextField("", value: $rest, formatter: NumberFormatter())
                    .focused($isRestFocused)
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
