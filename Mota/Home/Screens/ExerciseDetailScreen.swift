//
//  ExerciseDetailScreen.swift
//  Mota
//
//  Created by sam hastings on 31/01/2024.
//

import SwiftUI

struct ExerciseDetailScreen: View {
    var exercise: DatabaseExercise?
    
    
    
    var imageNames: [String?] {
        if let databaseExercise = exercise, !databaseExercise.imageURLs.isEmpty {
            return [databaseExercise.imageURLs[0], databaseExercise.imageURLs[1]]
        } else {
            return [nil,nil]
        }
    }
    
    var fullSizeImageURLs: [String?] {
        if let exercise {
            let baseURLString = "https://dbdf01bxei1cc.cloudfront.net/exercisesCleaned/"
//            return [
//                URL(string: baseURLString + "\(exercise.imageURLs[0]).jpg"),
//                URL(string: baseURLString + "\(exercise.imageURLs[1]).jpg")
//            ]
            return [
                baseURLString + "\(exercise.imageURLs[0]).jpg",
                baseURLString + "\(exercise.imageURLs[1]).jpg"
            ]
        } else {
            return [nil, nil]
        }
    }
    
    var body: some View {
        if let exercise = exercise {
            Text("\(exercise.name)")
                .font(.title)
            ExerciseAnimationView(imageNames: imageNames, fullSizeImageURLs: fullSizeImageURLs)
            Grid {
                GridRow {
                    Text("Primary Muscle")
                    Text("Equipment")
                    Text("Force")
                }
                .font(.headline)
                GridRow {
                    Text(exercise.primaryMuscles[0].rawValue.capitalized
                    )
                    if let equipment = exercise.equipment {
                        Text(equipment.rawValue.capitalized)
                    }
                    if let force = exercise.force {
                        Text(force.rawValue.capitalized)
                    }
                }
                GridRow {
                    Text("Category")
                    Text("Mechanic")
                    Text("Level")
                }
                .font(.headline)
                .padding(.top, 5)
                GridRow {
                    Text(exercise.category.rawValue.capitalized
                    )
                    if let mechanic = exercise.mechanic {
                        Text(mechanic.rawValue.capitalized)
                    }
                    
                    Text(exercise.level.rawValue.capitalized)
                    
                }
            }
            .padding()
            Text("Instructions")
                .font(.title2)
                .padding(.bottom, 5)
            ForEach(exercise.instructions, id: \.self) { instruction in
                Text(instruction)
                    .padding([.leading, .trailing])
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 2)
            }
        } else {
            Text("No info!")
        }

    }
}
#Preview {
    
//    return AsyncPreviewView(
//        asyncTasks: {
//            await SharedDatabase.preview.loadExercises()
//            return await SharedDatabase.preview.loadDummyExercise()
//        },
//        content: { exercise in
//            if let exercise = exercise as? DatabaseExercise {
//                ExerciseDetailScreen(exercise: exercise)
//            } else {
//                Text("No superset found.")
//            }
//        }
//    )
//    .environment(\.database, SharedDatabase.preview.database)
    return AsyncPreviewView(
            asyncTasks: {
                await SharedDatabase.preview.loadExercises()
                let workout =  await SharedDatabase.preview.loadDummyWorkoutTemplate()
                return workout
            },
            content: { workout in
                if let workout = workout as? WorkoutTemplate {
                    if let exercise = workout.orderedSupersets[0].orderedRounds[0].orderedSinglesets[0].exercise {
                        ExerciseDetailScreen(exercise: exercise)
                    } else {
                        Text("No exercise found.")
                    }
                } else {
                    Text("No workout found.")
                }
            }
        )
    .environment(\.database, SharedDatabase.preview.database)
}


