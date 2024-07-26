//
//  ExerciseImageView.swift
//  Mota
//
//  Created by sam hastings on 23/05/2024.
//

import SwiftUI
import SwiftData

struct ExerciseImageView: View {
    
    var exercise: DatabaseExercise?
    @State private var isExerciseDetailPresented = false
    var imageName: String? {
        if !(exercise?.imageURLs.isEmpty ?? false) {
            return exercise?.imageURLs[0]
        } else {
            return nil
        }
    }
    
    var body: some View {
        Button {
            // Don't use this action!!!
        } label: {
            SafeImageView(imageName: imageName, fullSizeImageURL: nil)
                .frame(width: 70, height: 70)
            .logCreation()
        }
        .onTapGesture {
            isExerciseDetailPresented.toggle()
        }
        .sheet(isPresented: $isExerciseDetailPresented) {
            ExerciseDetailScreen(exercise: exercise)
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
//                ExerciseImageView(exercise: exercise)
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
                if let workout = workout as? WorkoutNew {
                    if let exercise = workout.orderedSupersets[0].orderedRounds[0].orderedSinglesets[0].exercise {
                        ExerciseImageView(exercise: exercise)
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
