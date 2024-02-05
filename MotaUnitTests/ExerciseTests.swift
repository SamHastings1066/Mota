//
//  ExerciseTests.swift
//  MotaTests
//
//  Created by sam hastings on 30/01/2024.
//

import XCTest
@testable import Mota

final class WhenCreatingExerciseObject: XCTestCase {

    let jsonData = """
    [
        {
            "name": "3/4 Sit-Up",
            "force": "pull",
            "level": "beginner",
            "mechanic": "compound",
            "equipment": "body only",
            "primaryMuscles": [
              "abdominals"
            ],
            "secondaryMuscles": [],
            "instructions": [
              "Lie down on the floor and secure your feet. Your legs should be bent at the knees.",
              "Place your hands behind or to the side of your head. You will begin with your back on the ground. This will be your starting position.",
              "Flex your hips and spine to raise your torso toward your knees.",
              "At the top of the contraction your torso should be perpendicular to the ground. Reverse the motion, going only ¾ of the way down.",
              "Repeat for the recommended amount of repetitions."
            ],
            "category": "strength",
            "images": [
              "3_4_Sit-Up/0.jpg",
              "3_4_Sit-Up/1.jpg"
            ],
            "id": "3_4_Sit-Up"
          },
          {
            "name": "90/90 Hamstring",
            "force": "push",
            "level": "beginner",
            "mechanic": null,
            "equipment": "body only",
            "primaryMuscles": [
              "hamstrings"
            ],
            "secondaryMuscles": [
              "calves"
            ],
            "instructions": [
              "Lie on your back, with one leg extended straight out.",
              "With the other leg, bend the hip and knee to 90 degrees. You may brace your leg with your hands if necessary. This will be your starting position.",
              "Extend your leg straight into the air, pausing briefly at the top. Return the leg to the starting position.",
              "Repeat for 10-20 repetitions, and then switch to the other leg."
            ],
            "category": "stretching",
            "images": [
              "90_90_Hamstring/0.jpg",
              "90_90_Hamstring/1.jpg"
            ],
            "id": "90_90_Hamstring"
          },
          {
            "name": "Ab Crunch Machine",
            "force": "pull",
            "level": "intermediate",
            "mechanic": "isolation",
            "equipment": "machine",
            "primaryMuscles": [
              "abdominals"
            ],
            "secondaryMuscles": [],
            "instructions": [
              "Select a light resistance and sit down on the ab machine placing your feet under the pads provided and grabbing the top handles. Your arms should be bent at a 90 degree angle as you rest the triceps on the pads provided. This will be your starting position.",
              "At the same time, begin to lift the legs up as you crunch your upper torso. Breathe out as you perform this movement. Tip: Be sure to use a slow and controlled motion. Concentrate on using your abs to move the weight while relaxing your legs and feet.",
              "After a second pause, slowly return to the starting position as you breathe in.",
              "Repeat the movement for the prescribed amount of repetitions."
            ],
            "category": "strength",
            "images": [
              "Ab_Crunch_Machine/0.jpg",
              "Ab_Crunch_Machine/1.jpg"
            ],
            "id": "Ab_Crunch_Machine"
          },
    ]
    """.data(using: .utf8)!
    
    func testShouldCreateThreeObjects() throws {
        let exercisesTemp = try JSONDecoder().decode([Exercise].self, from: jsonData)
        XCTAssertEqual(exercisesTemp.count, 3)
        XCTAssertEqual(exercisesTemp[0].name, "3/4 Sit-Up")
        XCTAssertEqual(exercisesTemp[0].mechanic, Exercise.Mechanic.compound)
        XCTAssertEqual(exercisesTemp[1].mechanic, nil)
    }

}

final class WhenUsingLoadFunction: XCTestCase {
    
    func testExerciseObjectExists() throws {
        XCTAssertEqual(exercises[0].name, "3/4 Sit-Up")
        XCTAssertEqual(exercises[0].mechanic, Exercise.Mechanic.compound)
        XCTAssertEqual(exercises[1].mechanic, nil)
        XCTAssertEqual(exercises[3].name, "Ab Roller")
    }
}
