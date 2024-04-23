//
//  WorkoutNew.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import Foundation
import SwiftData

@Model
class WorkoutNew {
    var name: String
    let timeStamp: Date
    @Relationship(deleteRule: .cascade)
    var supersets: [SupersetNew]
    
    var orderedSupersets: [SupersetNew] {
        get {
            supersets.sorted{$0.timestamp < $1.timestamp}
        }
    }
    
    init(name: String = "New Workout", timestamp: Date = Date(), supersets: [SupersetNew] = [] ) {
        self.name = name
        self.timeStamp = timestamp
        self.supersets = supersets
    }
    
}

@Model
class SupersetNew {
    let timestamp: Date
    @Relationship(deleteRule: .cascade)
    var rounds: [Round]
    var orderedRounds: [Round] {
        rounds.sorted{$0.timestamp < $1.timestamp}
    }
    
    init(timestamp: Date = Date(), rounds: [Round] = []) {
        self.timestamp = timestamp
        self.rounds = rounds
    }
   
}

@Model
class Round {
    let timestamp: Date
    @Relationship(deleteRule: .cascade)
    var singlesets: [SinglesetNew]
    var rest: Int
    var orderedSinglesets: [SinglesetNew] {
        singlesets.sorted{$0.timestamp < $1.timestamp}
    }
    
    init(timestamp: Date = Date(), singlesets: [SinglesetNew] = [], rest: Int = 0) {
        self.timestamp = timestamp
        self.singlesets = singlesets
        self.rest = rest
    }
    
}

@Model
class SinglesetNew {
    let timestamp: Date
    var exercise: DatabaseExercise?
    var weight: Int
    var reps: Int
    
    init(timestamp: Date = Date(), exercise: DatabaseExercise = DatabaseExercise(), weight: Int = 0, reps: Int = 0) {
        self.timestamp = timestamp
        self.exercise = exercise
        self.weight = weight
        self.reps = reps
    }
    
    func updateWeight(_ weight: Int) {
        self.weight = weight
    }
    
    func updateReps(_ reps: Int) {
        self.reps = reps
    }
}
