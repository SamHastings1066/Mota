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
        
    init(superset: SupersetNew, isExpanded: Bool = false, isEditable: Bool = false, orderedSupersets: [SupersetNew]) {
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
        
        /// A collections of `CollapsedSingleset` objects. Each `CollapsedSingleset` has a stored property `singleSets` which is a collection the progressions of a specific `Singleset` through the rounds of a `Superset`
        var collapsedSinglesets: [CollapsedSingleset] {
            generateCollapsedSinglesets(from: superset.orderedRounds)
        }
        
        var numRounds: Int {
            get { superset.rounds.count }
            set {
                guard !superset.rounds.isEmpty else { return }
                guard newValue > 0 else { return }
                if newValue <= superset.rounds.count {
                    superset.rounds = Array(superset.orderedRounds[..<newValue])
                } else {
                    for _ in superset.rounds.count..<newValue {
                        superset.rounds.append(createRound(copying: superset.orderedRounds.last!))
                    }
                }
            }
        }
        
        var rest: Int? {
            get {
                let initialRest = superset.rounds[0].rest
                return superset.rounds.allSatisfy({ $0.rest == initialRest }) ? initialRest : nil
            }
            set { 
                if let newValue = newValue {
                    for round in superset.rounds {
                        round.rest = newValue
                    }
                }
            }
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
        
        func createRound(copying round: Round) -> Round {
            // Create new Singleset instances based on the ones in the existing Round
            let newSinglesets = round.orderedSinglesets.map { singleSet -> SinglesetNew in
                // Create a new Singleset with the same values
                SinglesetNew(exercise: singleSet.exercise ?? DatabaseExercise.sampleExercises[0], weight: singleSet.weight, reps: singleSet.reps)
            }
            // Create a new Round with these new Singleset instances
            let newRound = Round(singlesets: newSinglesets, rest: round.rest)
            return newRound
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
        var exercise: DatabaseExercise? {
            get {
                let initialExercise = singlesets[0].exercise
                return singlesets.allSatisfy({$0.exercise == initialExercise}) ? initialExercise : nil
            }
            set { for singleset in singlesets { singleset.updateExercise(newValue) }
            }
        }
        var imageName: String? {
            get {
                let initialImageName = singlesets[0].imageName
                return singlesets.allSatisfy({ $0.imageName == initialImageName }) ? initialImageName : nil
            }
        }
        
    
        init( singlesets: [SinglesetNew] = []) {
            self.singlesets = singlesets

        }
    }
    
    var body: some View {
            SupersetHeaderNewView(isExpanded: $isExpanded, isEditable: $isEditable, index: index)
            if isExpanded {
                ForEach(superset.orderedRounds) { round in
                    ExpandedRoundNewView(round: round, isEditable: $isEditable)
                }
            } else {
                HStack {
                    VStack {
                        ForEach(collapsedSuperset.collapsedSinglesets) { collapsedSingleset in
                            CollapsedSinglesetView(collapsedSingleset: collapsedSingleset)
                        }
                    }
                    CollapsedRoundInfoView(collapsedSuperset: $collapsedSuperset)
                        .padding()
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
//            SupersetNewView(superset: workout2.orderedSupersets[0], isExpanded: true, orderedSupersets: workout2.orderedSupersets)
//                .modelContainer(container)
            SupersetNewView(superset: workout2.orderedSupersets[0], isExpanded: false, orderedSupersets: workout2.orderedSupersets)
                .modelContainer(container)
        }
    } catch {
        fatalError("Failed to create model container")
    }
}
