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
                let start = Date()
                var rounds: [Round] = []
                if let lastRound = superset.orderedRounds.last {
                    for _ in superset.rounds.count..<newValue {
                        rounds.append(createRound(copying: lastRound))
                    }
                }
                superset.rounds.append(contentsOf: rounds)
                print("Copying took: \(Date().timeIntervalSince(start))")
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
    
    // TODO: Refactor this function and generateSinglesets. Merge them into one async function and make it more time efficient
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
    
    // TODO: improve the effiency of this function
    func generateSinglesets(from orderedRounds: [Round]) async -> [CollapsedSingleset] {
        let start = Date()
        var collapsedSinglesets = [CollapsedSingleset]() // O(1)
        guard !superset.rounds[0].singlesets.isEmpty else {return collapsedSinglesets} // O(1)
        let singlesetsCount = orderedRounds[0].singlesets.count // O(#singlesets in first round)
        
        let startFlattening = Date()
        var flatSinglesets = [SinglesetNew]()
        //let dummySets = [SinglesetNew(),SinglesetNew()]
        for round in orderedRounds { // O(n)
            // Ensure all rounds of superset have the same number of singlesets.
            //if round.singlesets.count != singlesetsCount {return [CollapsedSingleset]()}
            flatSinglesets.append(contentsOf: round.orderedSinglesets) // This is the line that takes ages. It is not the sorting of the singlesets since using round.singlesets takes just as long
            //flatSinglesets.append(contentsOf: dummySets) // this happens lightning fast!
        }
        print("flattening takes \(Date().timeIntervalSince(startFlattening))s")
        
        let start2DArray = Date()
        // Stores the the evolution of singlesets as user progresses through rounds
        let singlesetProgressions: [[SinglesetNew]] = {
            var returnArray = Array(repeating: Array(repeating: SinglesetNew(), count: flatSinglesets.count/singlesetsCount), count: singlesetsCount)
            for (index, element) in flatSinglesets.enumerated() { //O(n) - could do all of this in the loop above.
                returnArray[index % singlesetsCount][index / singlesetsCount] = element
            }
            return returnArray
        }()
        print("2D array takes \(Date().timeIntervalSince(start2DArray))s")
        
        let startCreatingCollapsedSinglesets = Date()
        for singlesetProgression in singlesetProgressions {
            collapsedSinglesets.append(CollapsedSingleset(singlesets: singlesetProgression))
        }
        print("singlesets take \(Date().timeIntervalSince(startCreatingCollapsedSinglesets))s")
        
        print("collapsedSinglesets generated in \(Date().timeIntervalSince(start))s")
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
    // TODO: Notice that weight, reps and exercise getters are all required to do a full pas through singlesets. Consider adding additional property to calculate them all in one pass, opr else consider making this more efficeint another way.
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
