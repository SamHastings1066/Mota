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
    
    // TODO: Instead of having a "superSetCollapsedRepresentation representation add the following computed properties directly to SuperSet
    // - var collapsedSingleSets: [SingleSet]
    // - var collapsedRest: Int?
    // Then in the setter for each of these computed properties you can handle the logic to update the exerciseRounds when either property is set
    // - collapsedRest set { for each exerciseRound in exerciseRounds, update the exerciseRound.rest = newValue }
    // - collapsedSingeSets set { }
    // The issue is you can have multiple SingleSets in the collapsedSingeSets. If you change e.g. the weight in one of them, you only want to change that weight, and not all of the properties in the collapsedSingeSets var. Ideally you would have each of these properties be computed properties in Superset so that when they are set you can handle the logic. But we  don't know how many singlesets will be in the collapsedSingleSet in advance of its creation so we con't do it this way.
    // SOLUTION: Create new computed vars:
    // - collapsedWeights: [Int?] - getter: each element takes an int value if the weight of the corresponding sigleset is the same across all exercise rounds. Setter: For each element in the array. if nil do nothing, if Int, set this Int as the weight for the corresponding singleset across all exercise rounds.
    // - collapsedReps: [Int?] - getter: each element takes an int value if the reps of the corresponding sigleset is the same across all exercise rounds. Setter: For each element in the array. if nil do nothing, if Int, set this Int as the reps for the corresponding singleset across all exercise rounds.
    // - consistentRest: Int? - getter: takes an Int value if the rest is the same for each exercise round in the superset. else nil. Setter - if nil, do nothing, if int, that is the rest for every exercise round in the superset.
    // Then get rid of colappsedRepresentsation var and just use these vars in the front end. Also in the front end UI get rid of references to the collapsedSuperset var and try to pass superset down the view hierarchy using environment, rather than passing a binding through each view.
    var constistentRest: Int? {
        get {
            let allRests = exerciseRounds.map { $0.rest }
            // TODO: make this line more readable
            //return allRests.allSatisfy { $0 == allRests.first } ? allRests.first != nil ? allRests.first! : nil : nil
            // Determine if the rest period is consistent across all rounds.
            let isConsistent = allRests.allSatisfy { $0 == allRests.first }
            return isConsistent ? allRests.first ?? nil : nil
            //return allRests.first!
            
        }
        set(newRest) {
            //print("REST SET \(newRest ?? 0 )")
            print("REST SET  \(newRest.map{"\($0)"} ?? "nil" )")
            //for index in exerciseRounds.indices { exerciseRounds[index].rest = newRest }
            exerciseRounds.indices.forEach { exerciseRounds[$0].rest = newRest ?? 0}
        }
    }
    var superSetCollapsedRepresentation: ExerciseRound {
        get {
            // Determine if the rest period is consistent across all rounds.
            let allRests = exerciseRounds.map { $0.rest }
            // TODO: make this line more readable
            let consistentRest = (allRests.allSatisfy { $0 == allRests.first } ? allRests.first != nil ? allRests.first! : nil : nil)
            
            // Prepare to collect unique exercises to analyze consistency across rounds.
            var exercisesTemplate: [SingleSet] = []
            if let firstRound = exerciseRounds.first?.singleSets {
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
                
                for round in exerciseRounds.map({ $0.singleSets }) {
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
            return ExerciseRound(singleSets: roundRepresentation, rest: consistentRest)
        }
        set {
            
        }
    }
    
    var numRounds: Int {
        get {
            exerciseRounds.count
        }
        set {
            exerciseRounds = (0..<newValue).map {_ in ExerciseRound(singleSets: exerciseRounds[0].singleSets, rest: exerciseRounds[0].rest) }
        }
    }
    
    var collapsedRepresentation: CollapsedSuperset { CollapsedSuperset(self) }
//        get {
//            //print("IS GET")
//            return CollapsedSuperset(self)
//        }
//        set {
//            print("IS SET")
//            print(newValue.superSetRepresentation.rest ?? "nil")
//            exerciseRounds = (0..<newValue.numRounds).map {_ in ExerciseRound(singleSets: exerciseRounds[0].singleSets, rest: exerciseRounds[0].rest) }
//            
//        }
//    }
    
    /// Initialize all superset parameters explicitly
    //init(exerciseRounds: [([SingleSet], Int)]) {
    init(exerciseRounds: [ExerciseRound]) {
        self.exerciseRounds = exerciseRounds
    }
    
    /// Initialise with one representative [SingleSet], a single rest time, and the number of rounds.
    init(singleSets: [SingleSet], rest: Int, numRounds: Int) {
        self.exerciseRounds = (0..<numRounds).map { _ in ExerciseRound(singleSets: singleSets, rest: rest) }
    }
    
    /// `CollapsedSuperset` is a `SuperSet` represented by a single `ExerciseRound`.
    /// `CollapsedSuperset` focuses on the commonalities of exercises across multiple rounds.
    ///
    /// This struct collapses the details of a `SuperSet` into a format where only the consistent attributes (weight and reps) across all rounds are preserved. If any attribute (weight or reps) varies across rounds for a given exercise, that attribute is set to `nil` in the final representation. The `rest` period is also simplified to a single value if it is consistent across all rounds; otherwise, it is set to `nil`.
    ///
    /// The primary use of `CollapsedSuperset` is to provide a concise summary of a `SuperSet` for display or analysis, where the focus is on identifying what is common across all rounds, thereby simplifying the complexity of the workout structure for certain views or logic within the app.
    class CollapsedSuperset {
        //var superSetRepresentation: (rounds: [SingleSet], rest: Int?)
        // TODO: Change this to superSetRepresentation
        var superSetRepresentation: ExerciseRound
        var numRounds: Int 

        init(_ superset: SuperSet) {
            numRounds = superset.numRounds
            superSetRepresentation = superset.superSetCollapsedRepresentation
        }
        
    }
    
}

/// `ExerciseRound` is a collection of single sets and the rest period following the completion of those single sets.
struct ExerciseRound: Identifiable {
    var id = UUID()
    var singleSets: [SingleSet]
    var rest: Int?
    
//    mutating func setRest(_ rest: Int?) {
//        self.rest = rest
//    }
}

/// `SingleSet` is the smallest component of a workout. It comprises the exercise being undertaken as well as the parameters of that exercise e.g. weight, repetitions.
struct SingleSet: Identifiable {
    
    var id = UUID()
    
    // TODO: Accomodate exercises other than weight training, either by increasing the list of optional parameters e.g. running would have a distance: Int? parameter, or another solution.
    
    var exercise: Exercise
    var weight: Int?
    var reps: Int?
}





