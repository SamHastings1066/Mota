//
//  WorkoutTests.swift
//  MotaTests
//
//  Created by sam hastings on 06/02/2024.
//

import XCTest
@testable import Mota
import SwiftData

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
        context.insert(set3Exercise0Weight120Reps4)
        context.insert(set4Exercise1Weight40Reps7)
        context.insert(set5Exercise0Weight100Reps11)
        context.insert(set6Exercise1Weight15Reps30)
        context.insert(set7Exercise0Weight120Reps8)
        // TODO: I need to have at least one context.insert here or the first test fails. Why do I need it? Why only one SingleSet and not all?
        context.insert(set8Exercise1Weight30Reps9)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testShouldCreateWorkoutObjectUsingExplicitSuperSetInit() throws {
        // Given
        let exerciseRound1 = ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:50)
        let exerciseRound2 = ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 50)
        let exerciseRound3 = ExerciseRound(singleSets: [set5Exercise0Weight100Reps11, set6Exercise1Weight15Reps30], rest:120)
        let exerciseRound4 = ExerciseRound(singleSets: [set7Exercise0Weight120Reps8,set8Exercise1Weight30Reps9], rest: 130)
        // TODO: If one of my exercise rounds is created using a duplicate SingleSet (i.e. a SingleSet that is used to create one of the other exercise rounds). then the test causes an error when setting the singleSets var for that exercise round.
        //let exerciseRound3 = ExerciseRound(singleSets: [set5Exercise0Weight100Reps11, set2Exercise1Weight50Reps6], rest:120)
        //let exerciseRound4 = ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 130)
        
        let superSet1 = SuperSet(exerciseRounds: [exerciseRound1, exerciseRound2])
        let superSet2 = SuperSet(exerciseRounds: [exerciseRound3, exerciseRound4])
        
        // When
        let workout = Workout(supersets: [superSet1, superSet2])
        

        // Then
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
    
    @MainActor
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
    
    @MainActor
    func testShouldAddSuperset() throws {
        
        //Given
        let superSet1 = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest: 50, numRounds: 8)
        let superSet2 = SuperSet(singleSets: [set7Exercise0Weight120Reps8, set8Exercise1Weight30Reps9], rest: 120, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1])
        context.insert(workout)
        try? context.save()
        XCTAssertEqual(workout.supersets.count, 1)
        
        // When
        workout.addSuperset(superSet2)
        try? context.save()
        
        // Then
        XCTAssertEqual(workout.supersets.count, 2)
    }
    
    @MainActor
    func testShouldDeleteSuperset() throws {
        // Given
        let superSet1 = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest: 50, numRounds: 8)
        let superSet2 = SuperSet(singleSets: [set7Exercise0Weight120Reps8, set8Exercise1Weight30Reps9], rest: 120, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1, superSet2])
        context.insert(workout)
        try? context.save()
        XCTAssertEqual(workout.supersets.count, 2)
        
        //When
        workout.deleteSuperset(superSet2)
        try? context.save()
        
        // Then
        XCTAssertEqual(workout.supersets.count, 1)
        
    }
    
    @MainActor
    func testThatDeletingNonExistentSupersetDoesNothing() throws {
        // Given
        let superSet1 = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest: 50, numRounds: 8)
        let superSet2 = SuperSet(singleSets: [set7Exercise0Weight120Reps8, set8Exercise1Weight30Reps9], rest: 120, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1])
        context.insert(workout)
        try? context.save()
        XCTAssertEqual(workout.supersets.count, 1)
        
        // When
        workout.deleteSuperset(superSet2)
        try? context.save()
        
        // Then
        XCTAssertEqual(workout.supersets.count, 1)
        
    }
    
    @MainActor
    func testShouldRemoveExerciseFromAllExerciseRounds() throws {
        // Given
        let superSet1 = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest: 50, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1])
        context.insert(workout)
        try? context.save()
        XCTAssertEqual(workout.supersets[0].consistentExercises.count, 2)
        XCTAssertEqual(workout.supersets[0].consistentExercises[0].name, databaseExercises[0].name)
        
        // When
        workout.supersets[0].removeExercise(databaseExercises[0])
        try? context.save()
        
        // Then
        XCTAssertEqual(workout.supersets[0].consistentExercises.count, 1)
        XCTAssertEqual(workout.supersets[0].consistentExercises[0].name, databaseExercises[1].name)
        
        
    }
    
    @MainActor
    func testShouldAddExerciseToAllExerciseRounds() throws {
        // Given
        let superSet1 = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest: 50, numRounds: 8)
        
        let workout = Workout(supersets: [superSet1])
        context.insert(workout)
        try? context.save()
        XCTAssertEqual(workout.supersets[0].consistentExercises.count, 2)
        
        // When
        workout.supersets[0].addExercise(databaseExercises[2])
        try? context.save()
        
        // Then
        XCTAssertEqual(workout.supersets[0].consistentExercises.count, 3)
        XCTAssertEqual(workout.supersets[0].consistentExercises[2].name, databaseExercises[2].name)
    }
}

final class WhenGettingSupersetComputedProperties: XCTestCase {
    private var databaseExercises: [DatabaseExercise]!
    private var context: ModelContext!

    private var set1Exercise0Weight100Reps5: SingleSet!
    private var set2Exercise1Weight50Reps6: SingleSet!
    private var set3Exercise0Weight120Reps4:  SingleSet!
    private var set4Exercise1Weight40Reps7: SingleSet!
    private var set5Exercise0Weight100Reps4: SingleSet!
    private var set6Exercise1Weight40Reps6: SingleSet!
    
    @MainActor
    override func setUp() {
        databaseExercises = ExerciseDataLoader.shared.databaseExercises
        context = mockContainer.mainContext
        
        set1Exercise0Weight100Reps5 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        set2Exercise1Weight50Reps6 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        set3Exercise0Weight120Reps4 =  SingleSet(exercise: databaseExercises[0], weight: 120, reps: 4)
        set4Exercise1Weight40Reps7 = SingleSet(exercise: databaseExercises[1], weight: 40, reps: 7)
        set5Exercise0Weight100Reps4 = SingleSet(exercise: databaseExercises[0], weight: 100, reps: 4)
        set6Exercise1Weight40Reps6 = SingleSet(exercise: databaseExercises[1], weight: 40, reps: 6)
        
        context.insert(set1Exercise0Weight100Reps5)
        context.insert(set2Exercise1Weight50Reps6)
        context.insert(set3Exercise0Weight120Reps4)
        context.insert(set4Exercise1Weight40Reps7)

    }
    // TODO: Understand why in testShouldPopulateAllCollapsedSupersetValuesWhenTheyAreTheSameForEachRoundInTheSuperSet i need to insert the superSet into the context and save it, whereas in testShouldOnlyPopulateCollapsedSupersetValuesIfTheyAreTheSameForEachRoundInTheSuperSet i do not. The difference is obviosuly to so with the fact that the SuperSets in the two tests are created using different initialisers. I KNOW WHY. In the second test, the same SingleSet objects that have already been added to the context are also used in the superset and so their parents can be automatically added into the context. In the first the SuperSet(superSets:) initialiser creates completely new SingleSet objects for each exercise round. These new singlesets have not been added to the context therefore none of the model structure is in the context automatically.
    
    @MainActor
    func testShouldPopulateAllCollapsedSupersetValuesWhenTheyAreTheSameForEachRoundInTheSuperSet() throws {
        // Given
        let superSet = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest: 50, numRounds: 4)
        context.insert(superSet)
        try? context.save()
        
        // Then
        XCTAssertEqual(superSet.consistentRest, 50)
        XCTAssertEqual(superSet.numRounds, 4)
        XCTAssertEqual(superSet.consistentExercises[0].name, databaseExercises[0].name)
        XCTAssertEqual(superSet.consistentExercises[1].name, databaseExercises[1].name)
        XCTAssertEqual(superSet.consistentWeights[0], 100)
        XCTAssertEqual(superSet.consistentWeights[1], 50)
        XCTAssertEqual(superSet.consistentReps[0], 5)
        XCTAssertEqual(superSet.consistentReps[1], 6)
        
    }
    
    @MainActor
    func testShouldOnlyPopulateCollapsedSupersetValuesIfTheyAreTheSameForEachRoundInTheSuperSet() throws {
        // Given
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:40), ExerciseRound(singleSets: [set5Exercise0Weight100Reps4,set6Exercise1Weight40Reps6], rest: 50)])
        context.insert(superSet)
        try? context.save()
        
        // Then
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
        
        
        context.insert(set1Exercise0Weight100Reps5)
        context.insert(set2Exercise1Weight50Reps6)
        context.insert(set3Exercise0Weight120Reps4)
        context.insert(set4Exercise1Weight40Reps7)
        context.insert(set5Exercise0Weight100Reps11)
        context.insert(set6Exercise1Weight15Reps30)
        context.insert(set7Exercise0Weight120Reps8)
        context.insert(set8Exercise1Weight30Reps9)
    }

    @MainActor
    func testThatExcessExercizeRoundsAreDroppedFromSupersetWhenTheCollapsedRepresentationNumroundsIsReduced() throws {
        // Given
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:40), ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 50), ExerciseRound(singleSets: [set5Exercise0Weight100Reps11,set6Exercise1Weight15Reps30], rest: 50)])

        // When
        superSet.numRounds = 2

        //Then
        XCTAssertEqual(superSet.exerciseRounds.count, 2)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[0].weight, 100)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[0].weight, 120)
    }
    
    @MainActor
    func testThatExercizeRoundsAreAddedToSupersetByDuplicatingFinalRoundWhenNumroundsIsIncreased() throws {
        // TODO: Due to the fact that orderedSingleSets uses the timestamp that a SingleSet was created to order them, ithe order they are listed in the singleSets array in the ExerciseRound initialiser has no impact.
        // Given
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:40), ExerciseRound(singleSets: [set4Exercise1Weight40Reps7, set5Exercise0Weight100Reps11], rest: 50), ExerciseRound(singleSets: [set3Exercise0Weight120Reps4, set6Exercise1Weight15Reps30], rest: 50)])

        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[1].weight, 100)
        // When
        superSet.numRounds = 4
        
        // Then
        XCTAssertEqual(superSet.exerciseRounds.count, 4)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[0].weight, 100)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[1].weight, 100)
        XCTAssertEqual(superSet.orderedExerciseRounds[3].orderedSingleSets[0].weight, 120)
        XCTAssertEqual(superSet.orderedExerciseRounds[3].orderedSingleSets[1].weight, 15)
    }
    
    @MainActor
    func testThatRestIsUpdatedForAllExerciseRoundsWhenConsistentRestIsSet() throws {
        // Given
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:40), ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 50), ExerciseRound(singleSets: [set5Exercise0Weight100Reps11,set6Exercise1Weight15Reps30], rest: 60)])

        // When
        superSet.consistentRest = 30

        // Then
        XCTAssertEqual(superSet.orderedExerciseRounds[0].rest, 30)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].rest, 30)
        XCTAssertEqual(superSet.orderedExerciseRounds[2].rest, 30)
    }
    
    @MainActor
    func testThatExercisesAreUpdatedForAllExerciseRoundsWhenConsistentExercisesIsSet() throws {
        // Given
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:40), ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 50)])

        // When
        superSet.consistentExercises = [databaseExercises[0], databaseExercises[2]]

        // Then
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[0].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[1].exercise?.name, databaseExercises[2].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[0].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[1].exercise?.name, databaseExercises[2].name)
    }
    
    @MainActor
    func testThatWeightIsUpdatedForCorrespondingSinglesetInAllExerciseRoundsWhenConsistentWeightIsSet() throws {
        // Given
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:40), ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 50)])

        // When
        superSet.consistentWeights = [130, nil]

        // Then
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[0].weight, 130)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[1].weight, 50)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[0].weight, 130)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[1].weight, 40)
    }
    
    @MainActor
    func testThatRepsIsUpdatedForCorrespondingSinglesetInAllExerciseRoundsWhenConsistentRepsIsSet() throws {

        // Given
        let superSet = SuperSet(exerciseRounds: [ExerciseRound(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest:40), ExerciseRound(singleSets: [set3Exercise0Weight120Reps4,set4Exercise1Weight40Reps7], rest: 50)])

        // When
        superSet.consistentReps = [nil, 7]

        // Then
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[0].reps, 5)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[1].reps, 7)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[0].reps, 4)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[1].reps, 7)
    }
}

// TODO: Finish off these tests
final class WhenSettingIdentifiableExercises: XCTestCase {
    private var databaseExercises: [DatabaseExercise]!
    private var context: ModelContext!

    private var set1Exercise0Weight100Reps5: SingleSet!
    private var set2Exercise1Weight50Reps6: SingleSet!
    private var set3Exercise2Weight120Reps4:  SingleSet!
    
    @MainActor
    override func setUp() {
        databaseExercises = ExerciseDataLoader.shared.databaseExercises
        context = mockContainer.mainContext
        
        set1Exercise0Weight100Reps5 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        set2Exercise1Weight50Reps6 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        set3Exercise2Weight120Reps4 =  SingleSet(exercise: databaseExercises[2], weight: 120, reps: 4)

        
        
        context.insert(set1Exercise0Weight100Reps5)
        context.insert(set2Exercise1Weight50Reps6)
        context.insert(set3Exercise2Weight120Reps4)
    }
    
    @MainActor
    func testThatOrderOfSingleSetsIsChangedForEachExerciseRound() throws {
        // Given
        let superSet = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6, set3Exercise2Weight120Reps4], rest: 50, numRounds: 8)
        context.insert(superSet)
        try? context.save()
        
        // When
        superSet.exercisesForReordering = [databaseExercises[2], databaseExercises[1], databaseExercises[0]]
        
        // Then
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[0].exercise?.name, databaseExercises[2].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[1].exercise?.name, databaseExercises[1].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[2].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[7].orderedSingleSets[0].exercise?.name, databaseExercises[2].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[7].orderedSingleSets[1].exercise?.name, databaseExercises[1].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[2].exercise?.name, databaseExercises[0].name)
        
    }
}

final class WhenAddingExerciseRounds: XCTestCase {
    private var databaseExercises: [DatabaseExercise]!
    private var context: ModelContext!

    private var set1Exercise0Weight100Reps5: SingleSet!
    private var set2Exercise1Weight50Reps6: SingleSet!
    private var set3Exercise2Weight120Reps4:  SingleSet!
    
    @MainActor
    override func setUp() {
        databaseExercises = ExerciseDataLoader.shared.databaseExercises
        context = mockContainer.mainContext
        
        set1Exercise0Weight100Reps5 =  SingleSet(exercise: databaseExercises[0], weight: 100, reps: 5)
        set2Exercise1Weight50Reps6 = SingleSet(exercise: databaseExercises[1], weight: 50, reps: 6)
        
        context.insert(set1Exercise0Weight100Reps5)
        context.insert(set2Exercise1Weight50Reps6)
    }
    
    @MainActor
    func testThatExerciseRoundIsAdded() throws {
        let superSet = SuperSet(singleSets: [set1Exercise0Weight100Reps5, set2Exercise1Weight50Reps6], rest: 50, numRounds: 8)
        context.insert(superSet)
        try? context.save()
        superSet.updateExerciseRound(with: databaseExercises[2])
        
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[0].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[1].exercise?.name, databaseExercises[1].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[0].orderedSingleSets[2].exercise?.name, databaseExercises[2].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[7].orderedSingleSets[0].exercise?.name, databaseExercises[0].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[7].orderedSingleSets[1].exercise?.name, databaseExercises[1].name)
        XCTAssertEqual(superSet.orderedExerciseRounds[1].orderedSingleSets[2].exercise?.name, databaseExercises[2].name)
        
    }
}
