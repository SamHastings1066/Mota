//
//  Workout.swift
//  Mota
//
//  Created by sam hastings on 06/02/2024.
//

import Foundation

/// `Workout` is a collection of supersets.
@Observable
class Workout {
    var supersets: [SuperSet]
    
    init(supersets: [SuperSet]) {
        self.supersets = supersets
    }
    
    func addSuperset(_ superSet: SuperSet) {
        supersets.append(superSet)
    }
}

/// `SuperSet` is a collection of exercise rounds.
struct SuperSet: Identifiable {
    var id = UUID()
    var exerciseRounds: [ExerciseRound]
    
    var numRounds: Int {
        get {
            exerciseRounds.count
        }
        set {
            guard !exerciseRounds.isEmpty else { return }
            //guard newValue > 0 else { return }
            if newValue <= exerciseRounds.count {
                exerciseRounds = Array(exerciseRounds[..<newValue])
            } else {
                let numberOfAdditionalRounds = newValue - exerciseRounds.count
                let newRounds = (0..<numberOfAdditionalRounds).map {_ in exerciseRounds.last! }
                exerciseRounds.append(contentsOf: newRounds)
            }
            //exerciseRounds = (0..<newValue).map {_ in ExerciseRound(singleSets: exerciseRounds[0].singleSets, rest: exerciseRounds[0].rest) }
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
    var consistentExercises: [Exercise] {
        get {
            exerciseRounds.first?.singleSets.map { $0.exercise } ?? []
        }
        set(newExercises) {
            guard newExercises.count == exerciseRounds.first?.singleSets.count else { return }
            for (exerciseIndex, exercise) in newExercises.enumerated() {
                exerciseRounds.indices.forEach { exerciseRounds[$0].singleSets[exerciseIndex].exercise = exercise}
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
            if let firstRound = exerciseRounds.first {
                for singleSet in firstRound.singleSets {
                    firstRoundWeights.append(singleSet.weight)
                }
            }
            for (index, _) in firstRoundWeights.enumerated() {
                var weightProgressionForThisExercise = [Int?]()
                for round in exerciseRounds.map({ $0.singleSets }) {
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
                    exerciseRounds.indices.forEach { exerciseRounds[$0].singleSets[exerciseIndex].weight = weight}
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
            if let firstRound = exerciseRounds.first {
                for singleSet in firstRound.singleSets {
                    firstRoundReps.append(singleSet.reps)
                }
            }
            for (index, _) in firstRoundReps.enumerated() {
                var repProgressionForThisExercise = [Int?]()
                for round in exerciseRounds.map({ $0.singleSets }) {
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
                    exerciseRounds.indices.forEach { exerciseRounds[$0].singleSets[exerciseIndex].reps = reps}
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
        self.exerciseRounds = (0..<numRounds).map { _ in ExerciseRound(singleSets: singleSets, rest: rest) }
    }

}

/// `ExerciseRound` is a collection of single sets and the rest period following the completion of those single sets.
struct ExerciseRound: Identifiable {
    var id = UUID()
    var singleSets: [SingleSet]
    var rest: Int?
}

/// `SingleSet` is the smallest component of a workout. It comprises the exercise being undertaken as well as the parameters of that exercise e.g. weight, repetitions.
struct SingleSet: Identifiable {
    var id = UUID()
    // TODO: Accomodate exercises other than weight training, either by increasing the list of optional parameters e.g. running would have a distance: Int? parameter, or another solution.
    var exercise: Exercise
    var weight: Int?
    var reps: Int?
}
