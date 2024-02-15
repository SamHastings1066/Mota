//
//  WorkoutTests.swift
//  MotaTests
//
//  Created by sam hastings on 06/02/2024.
//

import XCTest
@testable import Mota

final class WhenCreatingWorkoutObject: XCTestCase {
    
    //var workout: Workout!

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldCreateWorkoutObjectUsingExplicitSuperSetInit() throws {
        let set1 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 120, reps: 4)
        let set4 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 40, reps: 7)
        let superSet1 = SuperSet(sets: [ExerciseRound(round: [set1, set2], rest:50), ExerciseRound(round: [set3,set4], rest: 50)])
        
        
        // Create second superset
        let set5 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 11)
        let set6 = SingleSet(exercise: UserDefinedExercise(name: "Shoulder press"), weight: 15, reps: 30)
        let set7 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 120, reps: 8)
        let set8 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(sets: [ExerciseRound(round: [set5, set6], rest:120), ExerciseRound(round: [set7,set8], rest: 130)])
        let workout = Workout(supersets: [superSet1, superSet2])
        XCTAssertEqual(workout.supersets.count, 2)
        XCTAssertEqual(workout.supersets[0].sets.count, 2)
        XCTAssertEqual(workout.supersets[1].sets.count, 2)
        XCTAssertEqual(workout.supersets[1].sets[1].round[0].weight, 120)
        XCTAssertEqual(workout.supersets[1].sets[1].round[0].exercise.name, "Deadlift")
        XCTAssertEqual(workout.supersets[1].sets[1].round[1].exercise.name, DatabaseExercise.sampleExercises[1].name)
        XCTAssertEqual(workout.supersets[0].sets[0].rest, 50)
        XCTAssertEqual(workout.supersets[1].sets[0].rest, 120)
        XCTAssertEqual(workout.supersets[1].sets[1].rest, 130)
        
    }
    
    func testShouldCreateWorkoutObjectUsingNumRoundsSuperSetInit() throws {
        // Create first superset
        let set1 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let superSet1 = SuperSet(sets: [set1, set2], rest: 50, numRounds: 8)
        
        // Create second superset
        let set3 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        let set4 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(sets: [set3, set4], rest: 120, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1, superSet2])
        XCTAssertEqual(workout.supersets.count, 2)
        XCTAssertEqual(workout.supersets[0].sets.count, 8)
        XCTAssertEqual(workout.supersets[0].sets[0].round.count, 2)
        XCTAssertEqual(workout.supersets[0].sets[0].round[0].exercise.name, "Squat")
        XCTAssertEqual(workout.supersets[1].sets[0].round[0].exercise.name, DatabaseExercise.sampleExercises[0].name)
    }
    
    func testShouldAddSuperset() throws {
        // Create first superset
        let set1 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let superSet1 = SuperSet(sets: [set1, set2], rest: 50, numRounds: 8)
        
        // Create second superset
        let set3 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        let set4 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(sets: [set3, set4], rest: 120, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1])
        XCTAssertEqual(workout.supersets.count, 1)
        
        workout.addSuperset(superSet2)
        XCTAssertEqual(workout.supersets.count, 2)
        
    }
    
    



}

final class WhenGettingSupersetCollapsedRepresentation: XCTestCase {
    
    func testShouldPopulateAllCollapsedSupersetValuesWhenTheyAreTheSameForEachRoundInTheSuperSet() throws {
        let set1 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let superSet = SuperSet(sets: [set1, set2], rest: 50, numRounds: 8)
        
        let collapsedSuperSet = superSet.collapsedRepresentation //CollapsedSuperset(superSet)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rest, 50)
        XCTAssertEqual(collapsedSuperSet.numRounds, 8)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[0].exercise.name, "Squat")
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[0].weight, 100)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[0].reps, 5)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[1].exercise.name, "Bench")
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[1].weight, 50)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[1].reps, 6)
        
    }
    
    func testShouldOnlyPopulateCollapsedSupersetValuesIfTheyAreTheSameForEachRoundInTheSuperSet() throws {
        let set1 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 4)
        let set4 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 40, reps: 6)
        let superSet = SuperSet(sets: [ExerciseRound(round: [set1, set2], rest:40), ExerciseRound(round: [set3,set4], rest: 50)])
        
        let collapsedSuperSet = superSet.collapsedRepresentation //CollapsedSuperset(superSet)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rest, nil)
        XCTAssertEqual(collapsedSuperSet.numRounds, 2)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[0].exercise.name, "Squat")
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[0].weight, 100)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[0].reps, nil)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[1].exercise.name, "Bench")
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[1].weight, nil)
        XCTAssertEqual(collapsedSuperSet.setRepresentation.rounds[1].reps, 6)
        
    }
    
}

final class WhenSettingSupersetCollapsedRepresentation: XCTestCase {
    
    func testThatExcessExcersizeRoundsAreDroppedFromSupersetWhenTheCollapsedRepresentationNumroundsIsReduced() throws {
        let set1 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 5)
        let set2 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: UserDefinedExercise(name: "Squat"), weight: 100, reps: 4)
        let set4 = SingleSet(exercise: UserDefinedExercise(name: "Bench"), weight: 40, reps: 6)
        let superSet = SuperSet(sets: [ExerciseRound(round: [set1, set2], rest:40), ExerciseRound(round: [set3,set4], rest: 50)])
        
        superSet.collapsedRepresentation.numRounds = 1
        //XCTAssertEqual(superSet.sets.count, 1)
        
        
    }
}
