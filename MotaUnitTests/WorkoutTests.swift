//
//  WorkoutTests.swift
//  MotaTests
//
//  Created by sam hastings on 06/02/2024.
//

import XCTest
@testable import Mota

final class WhenCreatingWorkoutObject: XCTestCase {
    let databaseExercises = ExerciseDataLoader.shared.databaseExercises
    
    //var workout: Workout!

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldCreateWorkoutObjectUsingExplicitSuperSetInit() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: databaseExercises[0], weight: 120, reps: 4)
        let set4 = SingleSet(exercise: databaseExercises[1], weight: 40, reps: 7)
        let superSet1 = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1, set2], rest:50), ExerciseRound(singleSets: [set3,set4], rest: 50)])
        
        
        // Create second superset
        let set5 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 11)
        let set6 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 15, reps: 30)
        let set7 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        let set8 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set5, set6], rest:120), ExerciseRound(singleSets: [set7,set8], rest: 130)])
        let workout = Workout(supersets: [superSet1, superSet2])
        XCTAssertEqual(workout.supersets.count, 2)
        XCTAssertEqual(workout.supersets[0].exerciseRounds.count, 2)
        XCTAssertEqual(workout.supersets[1].exerciseRounds.count, 2)
        XCTAssertEqual(workout.supersets[1].exerciseRounds[1].singleSets[0].weight, 120)
        XCTAssertEqual(workout.supersets[1].exerciseRounds[1].singleSets[0].exercise?.name, DatabaseExercise.sampleExercises[0].name)
        XCTAssertEqual(workout.supersets[1].exerciseRounds[1].singleSets[1].exercise?.name, DatabaseExercise.sampleExercises[1].name)
        XCTAssertEqual(workout.supersets[0].exerciseRounds[0].rest, 50)
        XCTAssertEqual(workout.supersets[1].exerciseRounds[0].rest, 120)
        XCTAssertEqual(workout.supersets[1].exerciseRounds[1].rest, 130)
        
    }
    
    func testShouldCreateWorkoutObjectUsingNumRoundsSuperSetInit() throws {
        // Create first superset
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let superSet1 = SuperSet(singleSets: [set1, set2], rest: 50, numRounds: 8)
        
        // Create second superset
        let set3 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        let set4 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(singleSets: [set3, set4], rest: 120, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1, superSet2])
        XCTAssertEqual(workout.supersets.count, 2)
        XCTAssertEqual(workout.supersets[0].exerciseRounds.count, 8)
        XCTAssertEqual(workout.supersets[0].exerciseRounds[0].singleSets.count, 2)
        XCTAssertEqual(workout.supersets[0].exerciseRounds[0].singleSets[0].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(workout.supersets[1].exerciseRounds[0].singleSets[0].exercise?.name, DatabaseExercise.sampleExercises[0].name)
    }
    
    func testShouldAddSuperset() throws {
        // Create first superset
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let superSet1 = SuperSet(singleSets: [set1, set2], rest: 50, numRounds: 8)
        
        // Create second superset
        let set3 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        let set4 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(singleSets: [set3, set4], rest: 120, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1])
        XCTAssertEqual(workout.supersets.count, 1)
        
        workout.addSuperset(superSet2)
        XCTAssertEqual(workout.supersets.count, 2)
    }
    
    func testShouldDeleteSuperset() throws {
        // Create first superset
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let superSet1 = SuperSet(singleSets: [set1, set2], rest: 50, numRounds: 8)
        
        // Create second superset
        let set3 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        let set4 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        let superSet2 = SuperSet(singleSets: [set3, set4], rest: 120, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1, superSet2])
        XCTAssertEqual(workout.supersets.count, 2)
        
        workout.deleteSuperset(superSet2)
        XCTAssertEqual(workout.supersets.count, 1)
        
        // This should do nothing
        workout.deleteSuperset(superSet2)
        XCTAssertEqual(workout.supersets.count, 1)
        
    }
    
    func testShouldRemoveExerciseFromAllExerciseRounds() throws {
        // Create first superset
        let exerciseList = [databaseExercises[0], databaseExercises[1]]
        let set1 =  SingleSet(exercise: exerciseList[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: exerciseList[1], weight: 50, reps: 6)
        let superSet1 = SuperSet(singleSets: [set1, set2], rest: 50, numRounds: 8)
        
        
        
        let workout = Workout(supersets: [superSet1])
        XCTAssertEqual(workout.supersets[0].consistentExercises.count, 2)
        XCTAssertEqual(workout.supersets[0].consistentExercises[0].name, exerciseList[0].name)
        workout.supersets[0].removeExercise(exerciseList[0])
        XCTAssertEqual(workout.supersets[0].consistentExercises.count, 1)
        XCTAssertEqual(workout.supersets[0].consistentExercises[0].name, exerciseList[1].name)
        
        
    }
    
    func testShouldAddExerciseToAllExerciseRounds() throws {
        // Create first superset
        let exerciseList = [databaseExercises[0], databaseExercises[1], databaseExercises[2]]
        let set1 =  SingleSet(exercise: exerciseList[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: exerciseList[1], weight: 50, reps: 6)
        let superSet1 = SuperSet(singleSets: [set1, set2], rest: 50, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1])
        XCTAssertEqual(workout.supersets[0].consistentExercises.count, 2)
        workout.supersets[0].addExercise(exerciseList[2])
        XCTAssertEqual(workout.supersets[0].consistentExercises.count, 3)
        XCTAssertEqual(workout.supersets[0].consistentExercises[2].name, exerciseList[2].name)
        
        
    }
}

final class WhenGettingSupersetComputedProperties: XCTestCase {
    let databaseExercises = ExerciseDataLoader.shared.databaseExercises
    
    func testShouldPopulateAllCollapsedSupersetValuesWhenTheyAreTheSameForEachRoundInTheSuperSet() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let superSet = SuperSet(singleSets: [set1, set2], rest: 50, numRounds: 8)
        
        XCTAssertEqual(superSet.consistentRest, 50)
        XCTAssertEqual(superSet.numRounds, 8)
        XCTAssertEqual(superSet.consistentExercises[0].name, databaseExercises[0].name)
        XCTAssertEqual(superSet.consistentExercises[1].name, databaseExercises[1].name)
        XCTAssertEqual(superSet.consistentWeights[0], 100)
        XCTAssertEqual(superSet.consistentWeights[1], 50)
        XCTAssertEqual(superSet.consistentReps[0], 5)
        XCTAssertEqual(superSet.consistentReps[1], 6)
        
    }
    
    func testShouldOnlyPopulateCollapsedSupersetValuesIfTheyAreTheSameForEachRoundInTheSuperSet() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 4)
        let set4 = SingleSet(exercise: databaseExercises[1], weight: 40, reps: 6)
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1, set2], rest:40), ExerciseRound(singleSets: [set3,set4], rest: 50)])
        
        XCTAssertEqual(superSet.consistentRest, nil)
        XCTAssertEqual(superSet.numRounds, 2)
        XCTAssertEqual(superSet.consistentExercises[0].name, databaseExercises[0].name)
        XCTAssertEqual(superSet.consistentExercises[1].name, databaseExercises[1].name)
        XCTAssertEqual(superSet.consistentWeights[0], 100)
        XCTAssertEqual(superSet.consistentWeights[1], nil)
        XCTAssertEqual(superSet.consistentReps[0], nil)
        XCTAssertEqual(superSet.consistentReps[1], 6)
        
    }
    
}

final class WhenSettingSupersetComputedProperties: XCTestCase {
    let databaseExercises = ExerciseDataLoader.shared.databaseExercises
    
    func testThatExcessExercizeRoundsAreDroppedFromSupersetWhenTheCollapsedRepresentationNumroundsIsReduced() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: databaseExercises[0], weight: 110, reps: 4)
        let set4 = SingleSet(exercise: databaseExercises[1], weight: 60, reps: 5)
        let set5 =  SingleSet(exercise: databaseExercises[0], weight: 120, reps: 3)
        let set6 = SingleSet(exercise: databaseExercises[1], weight: 70, reps: 4)
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1, set2], rest:40), ExerciseRound(singleSets: [set3,set4], rest: 50), ExerciseRound(singleSets: [set5,set6], rest: 50)])

        superSet.numRounds = 2

        XCTAssertEqual(superSet.exerciseRounds.count, 2)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[0].weight, 100)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[0].weight, 110)
    }
    
    func testThatExercizeRoundsAreAddedToSupersetByDuplicatingFinalRoundWhenNumroundsIsIncreased() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: databaseExercises[0], weight: 110, reps: 4)
        let set4 = SingleSet(exercise: databaseExercises[1], weight: 60, reps: 5)
        let set5 =  SingleSet(exercise: databaseExercises[0], weight: 120, reps: 3)
        let set6 = SingleSet(exercise: databaseExercises[1], weight: 70, reps: 4)
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1, set2], rest:40), ExerciseRound(singleSets: [set3,set4], rest: 50), ExerciseRound(singleSets: [set5,set6], rest: 50)])

        superSet.numRounds = 4

        XCTAssertEqual(superSet.exerciseRounds.count, 4)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[0].weight, 100)
        XCTAssertEqual(superSet.exerciseRounds[3].singleSets[0].weight, 120)
    }
    
    func testThatRestIsUpdatedForAllExerciseRoundsWhenConsistentRestIsSet() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: databaseExercises[0], weight: 110, reps: 4)
        let set4 = SingleSet(exercise: databaseExercises[1], weight: 60, reps: 5)
        let set5 =  SingleSet(exercise: databaseExercises[0], weight: 120, reps: 3)
        let set6 = SingleSet(exercise: databaseExercises[1], weight: 70, reps: 4)
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1, set2], rest:40), ExerciseRound(singleSets: [set3,set4], rest: 50), ExerciseRound(singleSets: [set5,set6], rest: 60)])

        superSet.consistentRest = 30

        XCTAssertEqual(superSet.exerciseRounds[0].rest, 30)
        XCTAssertEqual(superSet.exerciseRounds[1].rest, 30)
        XCTAssertEqual(superSet.exerciseRounds[2].rest, 30)
    }
    
    func testThatExercisesAreUpdatedForAllExerciseRoundsWhenConsistentExercisesIsSet() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: databaseExercises[0], weight: 110, reps: 4)
        let set4 = SingleSet(exercise: databaseExercises[1], weight: 60, reps: 5)

        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1, set2], rest:40), ExerciseRound(singleSets: [set3,set4], rest: 50)])

        superSet.consistentExercises = [databaseExercises[0], DatabaseExercise.sampleExercises[1]]

        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[0].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[1].exercise?.name, DatabaseExercise.sampleExercises[1].name)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[0].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[1].exercise?.name, DatabaseExercise.sampleExercises[1].name)
    }
    
    func testThatWeightIsUpdatedForCorrespondingSinglesetInAllExerciseRoundsWhenConsistentWeightIsSet() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: databaseExercises[0], weight: 110, reps: 4)
        let set4 = SingleSet(exercise: databaseExercises[1], weight: 60, reps: 5)
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1, set2], rest:40), ExerciseRound(singleSets: [set3,set4], rest: 50)])

        superSet.consistentWeights = [130, nil]

        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[0].weight, 130)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[1].weight, 50)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[0].weight, 130)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[1].weight, 60)
    }
    
    func testThatRepsIsUpdatedForCorrespondingSinglesetInAllExerciseRoundsWhenConsistentRepsIsSet() throws {
        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let set3 =  SingleSet(exercise: databaseExercises[0], weight: 110, reps: 4)
        let set4 = SingleSet(exercise: databaseExercises[1], weight: 60, reps: 5)
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1, set2], rest:40), ExerciseRound(singleSets: [set3,set4], rest: 50)])

        superSet.consistentReps = [nil, 7]

        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[0].reps, 5)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[1].reps, 7)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[0].reps, 4)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[1].reps, 7)
    }
}

// TODO: Finish off these tests
final class WhenSettingIdentifiableExercises: XCTestCase {
    let databaseExercises = ExerciseDataLoader.shared.databaseExercises
    func testThatOrderOfSingleSetsIsChangedForEachExerciseRound() throws {
        let exerciseList = [databaseExercises[0], databaseExercises[1], databaseExercises[2]]
        let set1 =  SingleSet(exercise: exerciseList[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: exerciseList[1], weight: 50, reps: 6)
        let set3 = SingleSet(exercise: exerciseList[2], weight: 50, reps: 6)
        let superSet = SuperSet(singleSets: [set1, set2, set3], rest: 50, numRounds: 8)
        
        superSet.exercisesForReordering = [exerciseList[2], exerciseList[1], exerciseList[0]]
        
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[0].exercise?.name, exerciseList[2].name)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[1].exercise?.name, exerciseList[1].name)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[2].exercise?.name, exerciseList[0].name)
        XCTAssertEqual(superSet.exerciseRounds[7].singleSets[0].exercise?.name, exerciseList[2].name)
        XCTAssertEqual(superSet.exerciseRounds[7].singleSets[1].exercise?.name, exerciseList[1].name)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[2].exercise?.name, exerciseList[0].name)
        
        
        
    }
}
