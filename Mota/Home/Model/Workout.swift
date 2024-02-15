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
    var collapsedRepresentation: CollapsedSuperset {
        get {
            //print("IS GET")
            return CollapsedSuperset(self)
        }
        set {
            print("IS SET")
            print(newValue.superSetRepresentation.rest ?? "nil")
            // Here I have to change the value of the exerciseRounds: [ExerciseRound]
            // I need a function which takes a collapsed representation and generates [ExerciseRound] and then I need to use that function to set self.exerciseRounds when this collapsed rep is changed.
            // First option: a function that takes the first round of the current exerciseRounds and replicates it newValue.numRounds times
            // Ok so this is a solution, but it's not a great one. You need to think carefully about how you want to update the expanded view from the contracted view.
            
            exerciseRounds = (0..<newValue.numRounds).map {_ in ExerciseRound(singleSets: exerciseRounds[0].singleSets, rest: exerciseRounds[0].rest) }
            
        }
    }
    
    /// Initialize all superset parameters explicitly
    //init(exerciseRounds: [([SingleSet], Int)]) {
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

/// `CollapsedSuperset` is a `SuperSet` represented by a single `ExerciseRound`.
/// `CollapsedSuperset` focuses on the commonalities of exercises across multiple rounds.
///
/// This struct collapses the details of a `SuperSet` into a format where only the consistent attributes (weight and reps) across all rounds are preserved. If any attribute (weight or reps) varies across rounds for a given exercise, that attribute is set to `nil` in the final representation. The `rest` period is also simplified to a single value if it is consistent across all rounds; otherwise, it is set to `nil`.
///
/// The primary use of `CollapsedSuperset` is to provide a concise summary of a `SuperSet` for display or analysis, where the focus is on identifying what is common across all rounds, thereby simplifying the complexity of the workout structure for certain views or logic within the app.
@Observable
class CollapsedSuperset {
    //var superSetRepresentation: (rounds: [SingleSet], rest: Int?)
    // TODO: Change this to superSetRepresentation
    var superSetRepresentation: ExerciseRound
    var numRounds: Int
    
    init(_ superset: SuperSet) {
        self.numRounds = superset.exerciseRounds.count
        
        // Determine if the rest period is consistent across all rounds.
        let allRests = superset.exerciseRounds.map { $0.rest }
        // TODO: make this line more readable
        let consistentRest = allRests.allSatisfy { $0 == allRests.first } ? allRests.first != nil ? allRests.first! : nil : nil
        
        // Prepare to collect unique exercises to analyze consistency across rounds.
        var exercisesTemplate: [SingleSet] = []
        if let firstRound = superset.exerciseRounds.first?.singleSets {
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
            
            for round in superset.exerciseRounds.map({ $0.singleSets }) {
                weights.append(round[index].weight)
                reps.append(round[index].reps)
            }
            
            // If weights or reps are not consistent across all rounds, set them to nil.
            let isWeightConsistent = weights.allSatisfy { $0 == weights.first }
            let isRepsConsistent = reps.allSatisfy { $0 == reps.first }
            
            roundRepresentation[index].weight = isWeightConsistent ? weights.first!! : nil // Force unwrap is safe here due to how we're collecting weights
            roundRepresentation[index].reps = isRepsConsistent ? reps.first!! : nil // Same for reps
        }
        
        //self.setRepresentation = (rounds: roundRepresentation, rest: consistentRest)
        self.superSetRepresentation = ExerciseRound(singleSets: roundRepresentation, rest: consistentRest)
        
    }
}

/// `SingleSet` is the smallest component of a workout. It comprises the exercise being undertaken as well as the parameters of that exercise e.g. weight, repetitions.
struct SingleSet: Identifiable {
    
    var id = UUID()
    
    // TODO: Accomodate exercises other than weight training, either by increasing the list of optional parameters e.g. running would have a distance: Int? parameter, or another solution.
    
    var exercise: Exercise
    var weight: Int?
    var reps: Int?
}





