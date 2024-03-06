//
//  ExerciseRowView.swift
//  Mota
//
//  Created by sam hastings on 30/01/2024.
//

import SwiftUI

struct ExerciseRowView: View {
    var exercise: Exercise
    var imageName: String? {
        if let databaseExercise = exercise as? DatabaseExercise, !databaseExercise.imageURLs.isEmpty {
            return databaseExercise.imageURLs[0]
        } else {
            return nil
        }
    }
    
    var body: some View {
        HStack {
            SafeImage(imageName: imageName)
                        .frame(width: 50, height: 50)
            Text(exercise.name)
            Spacer()

            
        }
    }
}




#Preview {
    Group {
        ExerciseRowView(exercise: exercises[0])
        ExerciseRowView(exercise: exercises[4])
        
    }
    
}


