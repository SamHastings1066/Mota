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
        let superSet1 = SuperSet(sets: [(set: [set1, set2], rest:50), (set: [set3,set4], rest: 50)])
        
        // Create second superset
        let set5 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 100, reps: 11)
        let set6 = SingleSet(exercise: UserDefinedExercise(name: "Shoulder press"), weight: 15, reps: 30)
        let set7 =  SingleSet(exercise: UserDefinedExercise(name: "Deadlift"), weight: 120, reps: 8)
        let set8 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(sets: [(set: [set5, set6], rest:120), (set: [set7,set8], rest: 130)])
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
    
    



}

final class WhenCreatingCollapsedSupersetRepresentation {
    
    //test
    
}
