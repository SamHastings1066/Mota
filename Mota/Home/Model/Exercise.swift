//
//  DatabaseExercise.swift
//  Mota
//
//  Created by sam hastings on 30/01/2024.
//

// TODO: add in an imageSet computed var that is of type [Image?] which creates images using the strings in the images array

import Foundation
import SwiftData

@Model
class DatabaseExercise: Codable, Hashable, Identifiable {
    
    static func == (lhs: DatabaseExercise, rhs: DatabaseExercise) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: CodingKey {
        case id, name, force, level, mechanic, equipment, primaryMuscles, secondaryMuscles, instructions, category, images
    }
    
    let id: String
    let name: String
    let force: Force?
    let level: Level
    let mechanic: Mechanic?
    let equipment: Equipment?
    let primaryMuscles: [Muscle]
    let secondaryMuscles: [Muscle]
    let instructions: [String]
    let category: Category
    let images: [String]
    var singleSet: SingleSet?
    
    init() {
        id = UUID().uuidString
        name = ""
        level = Level.beginner
        primaryMuscles = [Muscle.abdominals]
        secondaryMuscles = [Muscle.abdominals]
        instructions = [""]
        category = Category.cardio
        images = [""]
    }
    
    init(from exercise: DatabaseExercise) {
        self.id = exercise.id
        self.name = exercise.name
        self.force = exercise.force
        self.level = exercise.level
        self.mechanic = exercise.mechanic
        self.equipment = exercise.equipment
        self.primaryMuscles = exercise.primaryMuscles
        self.secondaryMuscles = exercise.secondaryMuscles
        self.instructions = exercise.instructions
        self.category = exercise.category
        self.images = exercise.images
        self.singleSet = exercise.singleSet
    }

    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.force = try container.decodeIfPresent(DatabaseExercise.Force.self, forKey: .force)
        self.level = try container.decode(DatabaseExercise.Level.self, forKey: .level)
        self.mechanic = try container.decodeIfPresent(DatabaseExercise.Mechanic.self, forKey: .mechanic)
        self.equipment = try container.decodeIfPresent(DatabaseExercise.Equipment.self, forKey: .equipment)
        self.primaryMuscles = try container.decode([DatabaseExercise.Muscle].self, forKey: .primaryMuscles)
        self.secondaryMuscles = try container.decode([DatabaseExercise.Muscle].self, forKey: .secondaryMuscles)
        self.instructions = try container.decode([String].self, forKey: .instructions)
        self.category = try container.decode(DatabaseExercise.Category.self, forKey: .category)
        self.images = try container.decode([String].self, forKey: .images)
    }
    
    //Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(force, forKey: .force)
        try container.encode(level, forKey: .level)
        try container.encode(mechanic, forKey: .mechanic)
        try container.encode(equipment, forKey: .equipment)
        try container.encode(primaryMuscles, forKey: .primaryMuscles)
        try container.encode(secondaryMuscles, forKey: .secondaryMuscles)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(category, forKey: .category)
        try container.encode(images, forKey: .images)
    }
    
    var imageURLs: [String] {
        images.map{ imageString in
            imageString.hasSuffix(".jpg") ? String(imageString.dropLast(4)) : imageString }
    }

    enum Force: String, Codable {
        case `static`, pull, push
    }

    enum Level: String, Codable {
        case beginner, intermediate, expert
    }

    enum Mechanic: String, Codable {
        case isolation, compound
    }

    enum Equipment: String, Codable {
        case medicineBall = "medicine ball", dumbbell, bodyOnly = "body only", bands, kettlebells, foamRoll = "foam roll", cable, machine, barbell, exerciseBall = "exercise ball", eZCurlBar = "e-z curl bar", other
    }

    enum Muscle: String, Codable {
        case abdominals, abductors, adductors, biceps, calves, chest, forearms, glutes, hamstrings, lats, lowerBack = "lower back", middleBack = "middle back", neck, quadriceps, shoulders, traps, triceps
    }

    enum Category: String, Codable {
        case powerlifting, strength, stretching, cardio, olympicWeightlifting = "olympic weightlifting", strongman, plyometrics
    }
}

extension DatabaseExercise {
    static var sampleExercises: [DatabaseExercise] {
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

        do {
            let exercises = try JSONDecoder().decode([DatabaseExercise].self, from: jsonData)
            return exercises
        } catch {
            print("Error decoding sample data: \(error)")
            return []
        }
    }
}

extension DatabaseExercise {
    static var placeholder: DatabaseExercise {
//        return DatabaseExercise(
//            id: "placeholder",
//            name: "Placeholder Exercise",
//            force: Force.pull,
//            level: Level.beginner,
//            mechanic: Mechanic.compound,
//            equipment: Equipment.bands,
//            primaryMuscles: [],
//            secondaryMuscles: [],
//            instructions: [],
//            category: Category.cardio,
//            images: []
//        )
        return DatabaseExercise()
    }
}

