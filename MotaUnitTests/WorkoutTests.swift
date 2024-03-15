//
//  WorkoutTests.swift
//  MotaTests
//
//  Created by sam hastings on 06/02/2024.
//

import XCTest
@testable import Mota
import SwiftData

final class WhenCreatingWorkoutObject1: XCTestCase {
    private var databaseExercises: [DatabaseExercise]!
        
    private var superSet1: SuperSet!
    private var workout: Workout!
    private var context: ModelContext!
    
    private var set1Exercise0Weight100Reps5: SingleSet!
    private var set2Exercise1Weight50Reps6: SingleSet!
    private var set3Exercise0Weight120Reps4:  SingleSet!
    private var set4Exercise1Weight40Reps7: SingleSet!
    
    private var set5Exercise0Weight100Reps11:  SingleSet!
    private var set6Exercise1Weight15Reps30: SingleSet!
    private var set7Exercise0Weight120Reps8:  SingleSet!
    private var set8Exercise1Weight30Reps9: SingleSet!
    
    @MainActor
    override func setUp() {
        context = mockContainer.mainContext
        databaseExercises = ExerciseDataLoader.shared.databaseExercises
        set1Exercise0Weight100Reps5 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        set2Exercise1Weight50Reps6 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        set3Exercise0Weight120Reps4 =  SingleSet(exercise: databaseExercises[0], weight: 120, reps: 4)
        set4Exercise1Weight40Reps7 = SingleSet(exercise: databaseExercises[1], weight: 40, reps: 7)
        set5Exercise0Weight100Reps11 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 11)
        set6Exercise1Weight15Reps30 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 15, reps: 30)
        set7Exercise0Weight120Reps8 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        set8Exercise1Weight30Reps9 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        
        let exerciseRound1 = ExerciseRound(singleSets: [set1Exercise0Weight100Reps5], rest:50)
        superSet1 = SuperSet(exerciseRounds: [exerciseRound1])
        workout = Workout(supersets: [superSet1])
        context.insert(workout)
        
        //set1.exerciseRound = exerciseRound1
        //context.insert(superSet1) // duplicate registration attempt
        context.insert(exerciseRound1)
        //context.insert(set1)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldCreateWorkoutObjectUsingExplicitSuperSetInit() throws {
//        let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
//        let superSet1 = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1], rest:50)])
//        let workout = Workout(supersets: [superSet1])
        // Any operation with workout.addSuperset(), workout.supersets.count, etc. causes an error.
        // Perhaps this is because to exist workout needs to be added to the model context.
        XCTAssertEqual(workout.supersets.count, 1)
        print(workout.supersets[0].exerciseRounds[0].singleSets)
    }
}

final class WhenCreatingWorkoutObject: XCTestCase {
    
    private var databaseExercises: [DatabaseExercise]!
    private var context: ModelContext!
    
    private var set1Exercise0Weight100Reps5: SingleSet!
    private var set2Exercise1Weight50Reps6: SingleSet!
    private var set3Exercise0Weight120Reps4:  SingleSet!
    private var set4Exercise1Weight40Reps7: SingleSet!
    
    private var set5Exercise0Weight100Reps11:  SingleSet!
    private var set6Exercise1Weight15Reps30: SingleSet!
    private var set7Exercise0Weight120Reps8:  SingleSet!
    private var set8Exercise1Weight30Reps9: SingleSet!
    
    @MainActor
    override func setUp() {
        databaseExercises = ExerciseDataLoader.shared.databaseExercises
        context = mockContainer.mainContext
        
        set1Exercise0Weight100Reps5 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        set2Exercise1Weight50Reps6 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        set3Exercise0Weight120Reps4 =  SingleSet(exercise: databaseExercises[0], weight: 120, reps: 4)
        set4Exercise1Weight40Reps7 = SingleSet(exercise: databaseExercises[1], weight: 40, reps: 7)
        set5Exercise0Weight100Reps11 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 100, reps: 11)
        set6Exercise1Weight15Reps30 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 15, reps: 30)
        set7Exercise0Weight120Reps8 =  SingleSet(exercise: DatabaseExercise.sampleExercises[0], weight: 120, reps: 8)
        set8Exercise1Weight30Reps9 = SingleSet(exercise: DatabaseExercise.sampleExercises[1], weight: 30, reps: 9)
        
        
        // TODO: I need to have all context.insert here or the second test fails. Why do I need it? Why only all SingleSets for the second test and only one for the first test?
        context.insert(set1Exercise0Weight100Reps5)
        context.insert(set2Exercise1Weight50Reps6)
        context.insert(set7Exercise0Weight120Reps8)
        // TODO: I need to have at least one context.insert here or the first test fails. Why do I need it? Why only one SingleSet and not all?
        context.insert(set8Exercise1Weight30Reps9)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testShouldCreateWorkoutObjectUsingExplicitSuperSetInit() throws {
        let exerciseRound1 = ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:50)
        let exerciseRound2 = ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 50)
        let exerciseRound3 = ExerciseRound(singleSets: [set5Exercise0Weight100Reps11, set6Exercise1Weight15Reps30], rest:120)
        let exerciseRound4 = ExerciseRound(singleSets: [set7Exercise0Weight120Reps8,set8Exercise1Weight30Reps9], rest: 130)
        // TODO: If one of my exercise rounds is created using a duplicate SingleSet (i.e. a SingleSet that is used to create one of the other exercise rounds). then the test causes an error when setting the singleSets var for that exercise round.
        //let exerciseRound3 = ExerciseRound(singleSets: [set5Exercise0Weight100Reps11, set2Exercise1Weight50Reps6], rest:120)
        //let exerciseRound4 = ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 130)
        
        let superSet1 = SuperSet(exerciseRounds: [exerciseRound1, exerciseRound2])
        let superSet2 = SuperSet(exerciseRounds: [exerciseRound3, exerciseRound4])
        
        let workout = Workout(supersets: [superSet1, superSet2])
        
//        context.insert(exerciseRound1)
//        context.insert(exerciseRound2)
//        context.insert(exerciseRound3)
//        context.insert(exerciseRound4)
        //context.insert(workout)
        
        XCTAssertEqual(workout.supersets.count, 2)
        XCTAssertEqual(workout.supersets[0].exerciseRounds.count, 2)
        XCTAssertEqual(workout.supersets[1].exerciseRounds.count, 2)
        XCTAssertEqual(workout.orderedSuperSets[1].orderedExerciseRounds[1].orderedSingleSets[0].weight, 120)
        XCTAssertEqual(workout.orderedSuperSets[1].orderedExerciseRounds[1].orderedSingleSets[0].exercise?.name, DatabaseExercise.sampleExercises[0].name)
        XCTAssertEqual(workout.orderedSuperSets[1].orderedExerciseRounds[1].orderedSingleSets[1].exercise?.name, DatabaseExercise.sampleExercises[1].name)
        XCTAssertEqual(workout.orderedSuperSets[0].orderedExerciseRounds[0].rest, 50)
        XCTAssertEqual(workout.orderedSuperSets[1].orderedExerciseRounds[0].rest, 120)
        XCTAssertEqual(workout.orderedSuperSets[1].orderedExerciseRounds[1].rest, 130)
        
    }
    
    func testShouldCreateWorkoutObjectUsingNumRoundsSuperSetInit() throws {
        // Given
        let superSet1 = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest: 50, numRounds: 2)
        let superSet2 = SuperSet(singleSets: [set7Exercise0Weight120Reps8, set8Exercise1Weight30Reps9], rest: 120, numRounds: 2)
        
        // When
        let workout = Workout(supersets: [superSet1, superSet2])
        context.insert(workout)
        // Necessary because autosave is off by default for contexts created by hand, and save is necessary to add the newly created singlesets to the persistent layer.
        try? context.save()

        // Then
        XCTAssertEqual(workout.supersets.count, 2)
        XCTAssertEqual(workout.orderedSuperSets[0].orderedExerciseRounds.count, 2)
        XCTAssertEqual(workout.orderedSuperSets[0].orderedExerciseRounds[0].orderedSingleSets.count, 2)
        XCTAssertEqual(workout.orderedSuperSets[0].orderedExerciseRounds[0].orderedSingleSets[0].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(workout.orderedSuperSets[1].orderedExerciseRounds[0].orderedSingleSets[1].exercise?.name, databaseExercises[1].name)
    }
    
    func testShouldAddSuperset() throws {
        // Create first superset
        //let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let superSet1 = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2], rest: 50, numRounds: 8)
        
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
        //let set1 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        let superSet1 = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2], rest: 50, numRounds: 8)
        
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

final class WhenAddingExerciseRounds: XCTestCase {
    let databaseExercises = ExerciseDataLoader.shared.databaseExercises
    func testThatExerciseRoundIsAdded() throws {
        let exerciseList = [databaseExercises[0], databaseExercises[1], databaseExercises[2]]
        let set1 =  SingleSet(exercise: exerciseList[0], weight: 100, reps: 5)
        let set2 = SingleSet(exercise: exerciseList[1], weight: 50, reps: 6)
        let superSet = SuperSet(singleSets: [set1, set2], rest: 50, numRounds: 8)
        
        superSet.updateExerciseRound(with: exerciseList[2])
        
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[0].exercise?.name, exerciseList[0].name)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[1].exercise?.name, exerciseList[1].name)
        XCTAssertEqual(superSet.exerciseRounds[0].singleSets[2].exercise?.name, exerciseList[2].name)
        XCTAssertEqual(superSet.exerciseRounds[7].singleSets[0].exercise?.name, exerciseList[0].name)
        XCTAssertEqual(superSet.exerciseRounds[7].singleSets[1].exercise?.name, exerciseList[1].name)
        XCTAssertEqual(superSet.exerciseRounds[1].singleSets[2].exercise?.name, exerciseList[2].name)
        
    }
}
