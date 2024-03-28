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




//#Preview {
//    Group {
//        ExerciseRowView(exercise: databaseExercises[0])
//        ExerciseRowView(exercise: databaseExercises[4])
//        
//    }
//    
//}


