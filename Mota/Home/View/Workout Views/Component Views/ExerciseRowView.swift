//
//  ExerciseRowView.swift
//  Mota
//
//  Created by sam hastings on 30/01/2024.
//

import SwiftUI

struct ExerciseRowView: View {
    var exercise: DatabaseExercise
    var imageName: String? {
        if !exercise.imageURLs.isEmpty {
            return exercise.imageURLs[0]
        } else {
            return nil
        }
    }
    
    var body: some View {
        HStack {
            SafeImageView(imageName: imageName, fullSizeImageURL: nil)
                .frame(width: 50, height: 50)
            Text(exercise.name)
            Spacer()

            
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
//                ExerciseRowView(exercise: exercise)
//            } else {
//                Text("No superset found.")
//            }
//        }
//    )
//    .environment(\.database, SharedDatabase.preview.database) 
    return AsyncPreviewView(
            asyncTasks: {
                await SharedDatabase.preview.loadExercises()
                let workout =  await SharedDatabase.preview.loadDummyWorkout()
                return workout
            },
            content: { workout in
                if let workout = workout as? WorkoutTemplate {
                    if let exercise = workout.orderedSupersets[0].orderedRounds[0].orderedSinglesets[0].exercise {
                        ExerciseRowView(exercise: exercise)
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


