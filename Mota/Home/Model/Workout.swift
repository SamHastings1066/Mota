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
    
    mutating func addSuperset(_ superSet: SuperSet) {
        supersets.append(superSet)
    }
    
}

/// A collection of groups of sets. Each group of sets is a single round of a superset. The superset is the collection of all of those rounds.
struct SuperSet {
    var rest: Int
    var sets: [[SingleSet]]
    
    init(sets: [[SingleSet]], rest: Int) {
        self.rest = rest
        self.sets = sets
    }
    
    init(sets: [SingleSet], rest: Int, numRounds: Int) {
        self.rest = rest
        self.sets = [[SingleSet]](repeating: sets, count: numRounds)
    }
}

/// The smallest component of a workout. Comprises the exercise being undertaken as well as the parameters of that exercise e.g. weight, repetitions.
struct SingleSet {
    // TODO: Accomodate exercises other than weight training, either by increasing the list of optional parameters e.g. running would have a distance: Int? parameter, or another solution.
    
    var exercise: Exercise
    var weight: Int?
    var reps: Int?
}
