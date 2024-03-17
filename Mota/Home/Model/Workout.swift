//
//  Workout.swift
//  Mota
//
//  Created by sam hastings on 06/02/2024.
//

import Foundation
import SwiftData

/// `Workout` is a collection of supersets.
@Model
class Workout {
    @Relationship(deleteRule: .cascade, inverse: \SuperSet.workout)
    var supersets: [SuperSet] = []
    var orderedSuperSets: [SuperSet] {
        get {
            supersets.sorted{$0.timestamp < $1.timestamp}
        }
        set {
            for superset in newValue {
                superset.timestamp = Date()
            }
        }
    }
    
    init(supersets: [SuperSet]) {
        self.supersets = supersets
    }
    
    func addSuperset(_ superSet: SuperSet) {
        supersets.append(superSet)
    }
    
    func deleteSuperset(_ superSet: SuperSet) {
        let index = supersets.firstIndex(of: superSet)
        if let index = index {
            supersets.remove(at: index)
        }
    }
}

/// `SuperSet` is a collection of exercise rounds.
@Model
class SuperSet: Identifiable, Hashable {
    static func == (lhs: SuperSet, rhs: SuperSet) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    @Relationship(deleteRule: .cascade, inverse: \ExerciseRound.superSet)
    var exerciseRounds: [ExerciseRound] = []
    var orderedExerciseRounds: [ExerciseRound] {
        exerciseRounds.sorted{$0.timestamp < $1.timestamp}
    }
    var workout: Workout?
    var timestamp: Date = Date()
    
    
    var numRounds: Int {
        get {
            exerciseRounds.count
        }
        set {
            guard !exerciseRounds.isEmpty else { return }
            guard newValue > 0 else { return }
            if newValue <= exerciseRounds.count {
                exerciseRounds = Array(orderedExerciseRounds[..<newValue])
            } else {
                for _ in exerciseRounds.count..<newValue {
                    exerciseRounds.append(createExerciseRound(copying: orderedExerciseRounds.last!))
                }
            }
        }
    }
    
    /// `consistentRest`: Represents the rest period between exercise rounds within the superset.
    /// If all rounds have the same rest period, this property returns that common value.
    /// If the rest periods vary across rounds, it returns nil, indicating inconsistency.
    var consistentRest: Int? {
        get {
            guard let firstRest = exerciseRounds.first?.rest else { return nil }
            return exerciseRounds.dropFirst().allSatisfy { $0.rest == firstRest } ? firstRest : nil
        }
        set(newRest) {
            exerciseRounds.indices.forEach { exerciseRounds[$0].rest = newRest ?? 0}
        }
    }
    
    /// `consistentExercises`: Retrieves an array of exercises from the first round of the superset.
    /// This array is used to ensure consistency in displayed exercises across all rounds.
    /// Setting this property updates all rounds to have the specified exercises, maintaining consistency.
    var consistentExercises: [DatabaseExercise] {
        get {
//            let returnedExercises = exerciseRounds.first?.singleSets.map { $0.exercise ?? DatabaseExercise.placeholder } ?? []
//            return returnedExercises.sorted{$0.timeStamp<$1.timeStamp}
            orderedExerciseRounds.first?.orderedSingleSets.map { $0.exercise ?? DatabaseExercise.placeholder } ?? []
        }
        set(newExercises) {
            guard newExercises.count == orderedExerciseRounds.first?.orderedSingleSets.count else { return }
            for (exerciseIndex, exercise) in newExercises.enumerated() {
                orderedExerciseRounds.indices.forEach { orderedExerciseRounds[$0].orderedSingleSets[exerciseIndex].exercise = DatabaseExercise(from: exercise)}
            }
        }
    }
    
    var exercisesForReordering: [DatabaseExercise] {
        get {
            orderedExerciseRounds.first?.orderedSingleSets.map { $0.exercise ?? DatabaseExercise.placeholder } ?? []
        }
        set(newExercises) {
            for round in orderedExerciseRounds {
                newExercises.forEach { exercise in
                    let nextSinglet = round.singleSets.first(where: {$0.exercise == exercise})
                    nextSinglet?.updateTimeStamp()
                }
            }
        }
    }
    
    /// `consistentWeights`: Calculates and returns an array of optional integers, where each element
    /// corresponds to a consistent weight used for the same exercise across all rounds.
    /// If a weight varies across rounds for an exercise, the corresponding element is nil.
    /// Setting this property applies the specified weights to all corresponding exercises across all rounds.
    var consistentWeights: [Int?] {
        get {
            var firstRoundWeights: [Int?] = []
            // Array containing the weight Int if consistent across all rounds, else nil
            var consistentWeights = [Int?]()
            if let firstRound = orderedExerciseRounds.first {
                for singleSet in firstRound.orderedSingleSets {
                    firstRoundWeights.append(singleSet.weight)
                }
            }
            for (index, _) in firstRoundWeights.enumerated() {
                var weightProgressionForThisExercise = [Int?]()
                for round in orderedExerciseRounds.map({ $0.orderedSingleSets }) {
                    weightProgressionForThisExercise.append(round[index].weight)
                }
                let weightIsConsistent = weightProgressionForThisExercise.allSatisfy { $0 == firstRoundWeights[index] }
                consistentWeights.append(weightIsConsistent ? firstRoundWeights[index] : nil)
            }
            return consistentWeights
        }
        set(newWeights) {
            for (exerciseIndex, weight) in newWeights.enumerated() {
                if let weight = weight {
                    orderedExerciseRounds.indices.forEach { orderedExerciseRounds[$0].orderedSingleSets[exerciseIndex].weight = weight}
                }
            }
        }
    }
    
    /// `consistentReps`: Similar to `consistentWeights`, this property calculates and returns an array of
    /// optional integers representing the number of repetitions for exercises across all rounds.
    /// An element is nil if the reps for an exercise vary across rounds.
    /// Setting new values enforces the specified reps for all corresponding exercises in every round.
    var consistentReps: [Int?] {
        get {
            var firstRoundReps: [Int?] = []
            // Array containing the weight Int if consistent across all rounds, else nil
            var consistentReps = [Int?]()
            if let firstRound = orderedExerciseRounds.first {
                for singleSet in firstRound.orderedSingleSets {
                    firstRoundReps.append(singleSet.reps)
                }
            }
            for (index, _) in firstRoundReps.enumerated() {
                var repProgressionForThisExercise = [Int?]()
                for round in orderedExerciseRounds.map({ $0.orderedSingleSets }) {
                    repProgressionForThisExercise.append(round[index].reps)
                }
                let repIsConsistent = repProgressionForThisExercise.allSatisfy { $0 == firstRoundReps[index] }
                consistentReps.append(repIsConsistent ? firstRoundReps[index] : nil)
            }
            return consistentReps
        }
        
        set(newReps) {
            for (exerciseIndex, reps) in newReps.enumerated() {
                if let reps = reps {
                    orderedExerciseRounds.indices.forEach { orderedExerciseRounds[$0].orderedSingleSets[exerciseIndex].reps = reps}
                }
            }
        }
    }
    
    // TODO: Reduce Repetition: Current getters for consistentWeights and consistentReps iterate through all rounds for each single set to check for consistency. This can be optimized by consolidating the iteration logic, reducing redundancy.
    // TODO: Use map Efficiently: When setting new values for weights, reps, or exercises, you can utilize map more effectively to

    /// Initialize all superset parameters explicitly
    init(exerciseRounds: [ExerciseRound]) {
        self.exerciseRounds = exerciseRounds
    }
    
    /// Initialise with one representative [SingleSet], a single rest time, and the number of rounds.
    init(singleSets: [SingleSet], rest: Int, numRounds: Int) {
        self.exerciseRounds = (0..<numRounds).map { _ in
            var newSingleSets: [SingleSet] = []
            singleSets.forEach { singleSet in
                let newSingleSet = SingleSet(from: singleSet)
                newSingleSets.append(newSingleSet)
            }
            let newExerciseRound = ExerciseRound(singleSets: newSingleSets, rest: rest)
            return newExerciseRound
        }
    }
    
    func removeExercise(_ exerciseToRemove: DatabaseExercise) {
        // Iterate through each ExerciseRound
        for roundIndex in exerciseRounds.indices {
            // Filter out the SingleSet that matches the exercise to remove
            exerciseRounds[roundIndex].singleSets = exerciseRounds[roundIndex].singleSets.filter { $0.exercise?.id ?? "1" != exerciseToRemove.id }
        }
    }
    
    func addExercise(_ exerciseToAdd: DatabaseExercise) {
        for roundIndex in exerciseRounds.indices {
            exerciseRounds[roundIndex].singleSets.append(SingleSet(exercise: exerciseToAdd, weight: 0, reps: 0))
        }
    }
    
    func updateExerciseRound(with exerciseToAdd: DatabaseExercise) {
        var newRounds = [ExerciseRound]()
        for round in orderedExerciseRounds {
            var newSingleSets = round.orderedSingleSets.map { SingleSet(exercise: $0.exercise ?? DatabaseExercise.placeholder, weight: $0.weight, reps: $0.reps) }
            let newSingleSet = SingleSet(exercise: exerciseToAdd, weight: 0, reps: 0)
            newSingleSets.append(newSingleSet)
            let newExerciseRound = ExerciseRound(singleSets: newSingleSets, rest: round.rest)
            newRounds.append(newExerciseRound)
        }
        exerciseRounds = newRounds
    }
    
    func addSingleSet(_ singleSetToAdd: SingleSet) {
        for roundIndex in exerciseRounds.indices {
            exerciseRounds[roundIndex].singleSets.append(singleSetToAdd)
        }
    }

}

extension SuperSet {
    func createExerciseRound(copying exerciseRound: ExerciseRound) -> ExerciseRound {
        // Create new SingleSet instances based on the ones in the existing ExerciseRound
        let newSingleSets = exerciseRound.singleSets.map { singleSet -> SingleSet in
            // Create a new SingleSet with the same values
            SingleSet(exercise: singleSet.exercise ?? ExerciseDataLoader.shared.databaseExercises[0], weight: singleSet.weight, reps: singleSet.reps)
        }
        // Create a new ExerciseRound with these new SingleSet instances
        let newExerciseRound = ExerciseRound(singleSets: newSingleSets, rest: exerciseRound.rest)
        return newExerciseRound
    }
}

/// `ExerciseRound` is a collection of single sets and the rest period following the completion of those single sets.
@Model
class ExerciseRound: Identifiable {
    var id = UUID()
    @Relationship(deleteRule: .cascade, inverse: \SingleSet.exerciseRound)
    var singleSets: [SingleSet] = []
    var orderedSingleSets: [SingleSet] {
        singleSets.sorted{$0.timestamp < $1.timestamp}
    }
    var rest: Int?
    var superSet: SuperSet?
    let timestamp: Date = Date()
    
    init(singleSets: [SingleSet], rest: Int? = nil) {
        self.singleSets = singleSets
        self.rest = rest
    }
}

/// `SingleSet` is the smallest component of a workout. It comprises the exercise being undertaken as well as the parameters of that exercise e.g. weight, repetitions.
@Model
class SingleSet: Identifiable {
    var id = UUID()
    @Relationship(deleteRule: .cascade, inverse: \DatabaseExercise.singleSet)
    var exercise: DatabaseExercise?
    var weight: Int
    var reps: Int
    var exerciseRound: ExerciseRound?
    var timestamp: Date = Date()
    init(exercise: DatabaseExercise, weight: Int, reps: Int) {
        self.exercise = exercise
        self.weight = weight
        self.reps = reps
    }
    
    init(from singleSet : SingleSet) {
        self.exercise = singleSet.exercise
        self.weight = singleSet.weight
        self.reps = singleSet.reps
    }
    
    func updateTimeStamp() {
        self.timestamp = Date()
    }
}
