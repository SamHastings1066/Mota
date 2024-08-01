//
//  WorkoutTemplate.swift
//  Mota
//
//  Created by sam hastings on 17/04/2024.
//

import Foundation
import SwiftData

protocol WorkoutNew: Sendable {
    
    var supersets: [SupersetNew] { get set }
    
    func computeTotalReps() -> Int
    func computeTotalVolume() -> Int
    func computeMusclesUsed() -> [DatabaseExercise.Muscle: Int]
}

extension WorkoutNew {
    
    func computeTotalReps() -> Int {
        var totalReps = 0
        for superset in self.supersets {
            for round in superset.rounds {
                for singleset in round.singlesets {
                    totalReps += singleset.reps
                }
            }
        }
        return totalReps
    }
    
    func computeTotalVolume() -> Int {
        var totalVolume = 0
        for superset in self.supersets {
            for round in superset.rounds {
                for singleset in round.singlesets {
                    totalVolume += singleset.reps * singleset.weight
                }
            }
        }
        return totalVolume
    }
    
    func computeMusclesUsed() -> [DatabaseExercise.Muscle: Int] {
        return [DatabaseExercise.Muscle.abdominals: 10]
    }
}


@Model
final class WorkoutTemplate: Sendable, WorkoutNew {
    var id = UUID()
    var name: String
    let timeStamp: Date
    @Relationship(deleteRule: .cascade)
    var supersets: [SupersetNew]
    
    var orderedSupersets: [SupersetNew] {
        get {
            supersets.sorted{$0.timestamp < $1.timestamp}
        }
        set {
            for superset in newValue {
                superset.timestamp = Date()
            }
        }
    }
    
    init(name: String = "New Workout", timestamp: Date = Date(), supersets: [SupersetNew] = [] ) {
        self.name = name
        self.timeStamp = timestamp
        self.supersets = supersets
    }
    
    func addSuperset(_ superset: SupersetNew) {
        supersets.append(superset)
    }
    
    func deleteSuperset(_ superset: SupersetNew) {
        let index = supersets.firstIndex(of: superset)
        if let index = index {
            supersets.remove(at: index)
        }
    }
    
}

@Model
final class WorkoutCompleted: Sendable, WorkoutNew {
    var id = UUID()
    var name: String
    let timeStamp: Date
    @Relationship(deleteRule: .cascade)
    var supersets: [SupersetNew]
    var startTime: Date
    var endTime: Date
    
    var orderedSupersets: [SupersetNew] {
        get {
            supersets.sorted { $0.timestamp < $1.timestamp }
        }
        set {
            for superset in newValue {
                superset.timestamp = Date()
            }
        }
    }
    
    init(name: String = "Completed Workout", timestamp: Date = Date(), supersets: [SupersetNew] = [], startTime: Date = Date(), endTime: Date = Date()) {
        self.name = name
        self.timeStamp = timestamp
        self.supersets = supersets
        self.startTime = startTime
        self.endTime = endTime
    }
    
    init(workout: WorkoutTemplate, startTime: Date = Date(), endTime: Date = Date()) {
        let copiedSupersets: [SupersetNew] = {
            var result = [SupersetNew]()
            for superset in workout.supersets {
                result.append(superset.copy())
            }
            return result
        }()
        self.name = workout.name
        self.timeStamp = workout.timeStamp
        self.supersets = copiedSupersets
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func addSuperset(_ superset: SupersetNew) {
        supersets.append(superset)
    }
    
    func deleteSuperset(_ superset: SupersetNew) {
        if let index = supersets.firstIndex(of: superset) {
            supersets.remove(at: index)
        }
    }
//    func computeTotalSupersets() -> Int {
//        return supersets.count
//    }
}

@Model
class SupersetNew {
    var timestamp: Date
    @Relationship(deleteRule: .cascade)
    var rounds: [Round]
    var orderedRounds: [Round] {
        rounds.sorted{$0.timestamp < $1.timestamp}
    }
    
    init(timestamp: Date = Date(), rounds: [Round] = []) {
        self.timestamp = timestamp
        self.rounds = rounds
    }
    
    func copy() -> SupersetNew {
        let copiedRounds: [Round] = {
            var result = [Round]()
            for round in rounds {
                result.append(round.copy())
            }
            return result
        }()
        return SupersetNew(timestamp: timestamp, rounds: copiedRounds)
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
    
    func copy() -> Round {
        let copiedSinglesets: [SinglesetNew] = {
            var result = [SinglesetNew]()
            for singleset in singlesets {
                result.append(singleset.copy())
            }
            return result
        }()
        return Round(timestamp: timestamp, singlesets: copiedSinglesets, rest: rest)
    }
    
}

@Model
class SinglesetNew {
    var timestamp: Date
    var exercise: DatabaseExercise?
    var weight: Int
    var reps: Int
    
    var imageName: String? {
        if !(exercise?.imageURLs.isEmpty ?? false) {
            return exercise?.imageURLs[0]
        } else {
            return nil
        }
    }
    
    init(timestamp: Date = Date(), exercise: DatabaseExercise? = DatabaseExercise(), weight: Int = 0, reps: Int = 0) {
        self.timestamp = timestamp
        self.exercise = exercise
        self.weight = weight
        self.reps = reps
    }
    
    func copy() -> SinglesetNew {
        return SinglesetNew(timestamp: timestamp, exercise: exercise, weight: weight, reps: reps)
    }
    
    func updateWeight(_ weight: Int) {
        self.weight = weight
    }
    
    func updateReps(_ reps: Int) {
        self.reps = reps
    }
    
    func updateExercise(_ exercise: DatabaseExercise?) {
        self.exercise = exercise
    }
    
    func updateTimeStamp() {
        self.timestamp = Date()
    }
}
