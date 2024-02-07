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
struct SuperSet {
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

//struct CollapsedSuperset {
//    //var rest: Int?
//    var sets: [(name: String, weight: Int?, reps: Int?)]
//    var numRounds: Int
//    
//    init(superset: SuperSet) {
//        
//    }
//}

/// The smallest component of a workout. Comprises the exercise being undertaken as well as the parameters of that exercise e.g. weight, repetitions.
struct SingleSet {
    // TODO: Accomodate exercises other than weight training, either by increasing the list of optional parameters e.g. running would have a distance: Int? parameter, or another solution.
    
    var exercise: Exercise
    var weight: Int?
    var reps: Int?
}





