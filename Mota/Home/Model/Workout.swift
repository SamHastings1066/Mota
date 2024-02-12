//
//  Workout.swift
//  Mota
//
//  Created by sam hastings on 06/02/2024.
//

import Foundation

/// A collection of supersets.
struct Workout {
    var supersets: [SuperSet]
    //var numRounds: Int { supersets.count } // TODO: write test for this
    
    mutating func addSuperset(_ superSet: SuperSet) {
        supersets.append(superSet)
    }
    
}



/// A collection of (round, rest) tuples. Each round is a collection of `SingleSet` instances. A round is therefore all of the exercises done back-ro-back before a rest is taken.
struct SuperSet: Identifiable {
    var id = UUID() // TODO: Change this to something more sensible
    
    //var rest: Int
    var sets: [(round: [SingleSet], rest: Int)]
    
    /// Initial all superset parameters explicitly
    init(sets: [([SingleSet], Int)]) {
        self.sets = sets
    }
    
    /// Initialise with one representative [SingleSet], a single rest time, and the number of rounds.
    init(sets: [SingleSet], rest: Int, numRounds: Int) {
        self.sets = [([SingleSet], Int)](repeating: (sets, rest), count: numRounds)
    }
}

/// `CollapsedSuperset` represents a simplified version of a `SuperSet`, focusing on the commonalities of exercises across multiple rounds.
///
/// This struct collapses the details of a `SuperSet` into a format where only the consistent attributes (weight and reps) across all rounds are preserved. If any attribute (weight or reps) varies across rounds for a given exercise, that attribute is set to `nil` in the final representation. The `rest` period is also simplified to a single value if it is consistent across all rounds; otherwise, it is set to `nil`.
///
/// The primary use of `CollapsedSuperset` is to provide a concise summary of a `SuperSet` for display or analysis, where the focus is on identifying what is common across all rounds, thereby simplifying the complexity of the workout structure for certain views or logic within the app.
struct CollapsedSuperset {
    var setRepresentation: (rounds: [SingleSet], rest: Int?)
    var numRounds: Int
    
    init(_ superset: SuperSet) {
        self.numRounds = superset.sets.count
        
        // Determine if the rest period is consistent across all rounds.
        let allRests = superset.sets.map { $0.rest }
        let consistentRest = allRests.allSatisfy { $0 == allRests.first } ? allRests.first : nil
        
        // Prepare to collect unique exercises to analyze consistency across rounds.
                var exercisesTemplate: [SingleSet] = []
                if let firstRound = superset.sets.first?.round {
                    for singleSet in firstRound {
                        let singleSet = SingleSet(exercise: singleSet.exercise, weight: singleSet.weight, reps: singleSet.reps)
                        exercisesTemplate.append(singleSet)
                    }
                }

                // Analyze each round to check for consistency in weight and reps.
                var roundRepresentation: [SingleSet] = exercisesTemplate.map { SingleSet(exercise: $0.exercise, weight: $0.weight, reps: $0.reps) }
                
                for (index, _) in exercisesTemplate.enumerated() {
                    var weights = [Int?]()
                    var reps = [Int?]()

                    for round in superset.sets.map({ $0.round }) {
                        weights.append(round[index].weight)
                        reps.append(round[index].reps)
                    }

                    // If weights or reps are not consistent across all rounds, set them to nil.
                    let isWeightConsistent = weights.allSatisfy { $0 == weights.first }
                    let isRepsConsistent = reps.allSatisfy { $0 == reps.first }
                    
                    roundRepresentation[index].weight = isWeightConsistent ? weights.first!! : nil // Force unwrap is safe here due to how we're collecting weights
                    roundRepresentation[index].reps = isRepsConsistent ? reps.first!! : nil // Same for reps
                }

                self.setRepresentation = (rounds: roundRepresentation, rest: consistentRest)
            
    }
}


/// The smallest component of a workout. Comprises the exercise being undertaken as well as the parameters of that exercise e.g. weight, repetitions.
struct SingleSet: Identifiable {
    
    var id = UUID()
    
    // TODO: Accomodate exercises other than weight training, either by increasing the list of optional parameters e.g. running would have a distance: Int? parameter, or another solution.
    
    var exercise: Exercise
    var weight: Int?
    var reps: Int?
}





