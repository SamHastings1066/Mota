//
//  CollapsedSuperset.swift
//  Mota
//
//  Created by sam hastings on 16/05/2024.
//

import Foundation

@Observable
class CollapsedSuperset: Identifiable {
    var id = UUID()
    var superset: SupersetNew
    
    /// A collection of `CollapsedSingleset` objects. Each `CollapsedSingleset` has a stored property `singleSets` which is a collection the progressions of a specific `Singleset` through the rounds of a `Superset`
    var collapsedSinglesets: [CollapsedSingleset] {
        generateCollapsedSinglesets(from: superset.orderedRounds)
    }
    
    var exercises: [DatabaseExercise] {
        get {
            var exercises = [DatabaseExercise]()
            for collapsedSingleset in collapsedSinglesets {
                if let exercise = collapsedSingleset.exercise {
                    exercises.append(exercise)
                }
            }
            return exercises
        }
        set(newExerciseOrder) {
            for round in superset.orderedRounds {
                newExerciseOrder.forEach { exercise in
                    let nextSinglet = round.singlesets.first(where: {$0.exercise == exercise})
                    nextSinglet?.updateTimeStamp()
                }
            }
        }
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
        guard !superset.rounds[0].singlesets.isEmpty else {return collapsedSinglesets}
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
    
    func addSingleset(with exercise: DatabaseExercise) {
        for roundIndex in superset.rounds.indices {
            superset.rounds[roundIndex].singlesets.append(SinglesetNew(exercise: exercise, weight: 0, reps: 0))
        }
    }
    func removeSingleSet(_ collapsedSingleset: CollapsedSingleset) {
        let exerciseToRemove = collapsedSingleset.exercise
        if let exerciseToRemove {
            for roundIndex in superset.rounds.indices {
                // Filter out the SingleSet that matches the exercise to remove
                superset.rounds[roundIndex].singlesets = superset.rounds[roundIndex].singlesets.filter { $0.exercise?.id ?? "1" != exerciseToRemove.id }
            }
        }
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
