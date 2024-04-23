//
//  SupersetNewView.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import SwiftUI
import SwiftData

struct SupersetNewView: View {
    
    @Bindable var superset: SupersetNew
    @State var isExpanded: Bool
    @State private var isEditable : Bool
    var orderedSupersets: [SupersetNew]
    
    @State var collapsedSuperset: CollapsedSuperset
        
    init(superset: SupersetNew, isExpanded: Bool = true, isEditable: Bool = false, orderedSupersets: [SupersetNew]) {
        self.superset = superset
        self.isExpanded = isExpanded
        self.isEditable = isEditable
        self.orderedSupersets = orderedSupersets
        self.collapsedSuperset = CollapsedSuperset(superset: superset)
    }
    
    var index: Int {
        if let index = orderedSupersets.firstIndex(where: { $0.id == superset.id }) {
            return index
        } else {
            return 0
        }
    }
    
    @Observable
    class CollapsedSuperset: Identifiable {
        var id = UUID()
        var superset: SupersetNew
        
        // TODO: Clean this up
        var collapsedSinglesets: [CollapsedSingleset] {
            generateCollapsedSinglesets(from: superset.orderedRounds)
        }
        
        init(superset: SupersetNew = SupersetNew()) {
            self.superset = superset
        }
        
        func generateCollapsedSinglesets(from orderedRounds: [Round]) -> [CollapsedSingleset] {
            var collapsedSinglesets = [CollapsedSingleset]()
            let singlesetsCount = orderedRounds[0].singlesets.count
            
            // Ensure all rounds of superset have the same number of singlesets.
            guard orderedRounds.allSatisfy({ $0.singlesets.count == singlesetsCount }) else { return collapsedSinglesets }
            
            
            var flatSinglesets = [SinglesetNew]()
            for round in orderedRounds {
                flatSinglesets.append(contentsOf: round.orderedSinglesets)
            }
            
            // Stores the the evolution of singlesets as user progresses through rounds
            let singlesetProgressions: [[SinglesetNew]] = {
                var returnArray = Array(repeating: Array(repeating: SinglesetNew(), count: flatSinglesets.count/singlesetsCount), count: singlesetsCount)
                for (index, element) in flatSinglesets.enumerated() {
                    returnArray[index % singlesetsCount][index / singlesetsCount] = element
                }
                return returnArray
            }()
            
            for singlesetProgression in singlesetProgressions {
                collapsedSinglesets.append(CollapsedSingleset(singlesets: singlesetProgression))
            }
            
            return collapsedSinglesets
        }

    }
    
    @Observable
    class CollapsedSingleset: Identifiable {

        var id = UUID()
        var singlesets: [SinglesetNew]
        var weight: Int {
            get {
                let initialWeight = singlesets[0].weight
                return singlesets.allSatisfy({ $0.weight == initialWeight }) ? initialWeight : 0
            }
            set { for singleset in singlesets { singleset.updateWeight(newValue) } }
        }
        var reps: Int {
            get {
                let initialReps = singlesets[0].reps
                return singlesets.allSatisfy({ $0.reps == initialReps }) ? initialReps : 0
            }
            set { for singleset in singlesets { singleset.updateReps(newValue) } }
        }
    
        init( singlesets: [SinglesetNew] = []) {
            self.singlesets = singlesets

        }
    }
    
    var body: some View {
        VStack {
            SupersetHeaderNewView(isExpanded: $isExpanded, isEditable: $isEditable, index: index)
            if isExpanded {
                ForEach(superset.orderedRounds) { round in
                    ExpandedRoundNewView(round: round, isEditable: $isEditable)
                }
            } else {

                ForEach(collapsedSuperset.collapsedSinglesets) { collapsedSingleset in
                    CollapsedSinglesetView(collapsedSingleset: collapsedSingleset)
                }
                Text("Placeholder")
            }
            
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        
        let workout2 = WorkoutNew(name: "Arms workout",
            supersets: [
                SupersetNew(
                    rounds: [
                        Round(
                            singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)],
                            rest:  60
                        ),
                        Round(
                            singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[0], weight: 90, reps: 10), SinglesetNew(exercise: DatabaseExercise.sampleExercises[1], weight: 90, reps: 15)],
                            rest:  70
                        )
                    ]
                ),
                SupersetNew(
                    rounds: [
                        Round(singlesets: [SinglesetNew(exercise: DatabaseExercise.sampleExercises[2], weight: 10, reps: 20)]),
                    ]
                )
            ]
        )
        
        container.mainContext.insert(workout2)
        
        return Group {
            SupersetNewView(superset: workout2.orderedSupersets[0], isExpanded: true, orderedSupersets: workout2.orderedSupersets)
                .modelContainer(container)
            SupersetNewView(superset: workout2.orderedSupersets[0], isExpanded: false, orderedSupersets: workout2.orderedSupersets)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
