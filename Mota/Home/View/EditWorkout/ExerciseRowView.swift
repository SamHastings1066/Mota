//
//  ExerciseRowView.swift
//  Mota
//
//  Created by sam hastings on 30/01/2024.
//

import SwiftUI

struct ExerciseRowView: View {
    var exercise: DatabaseExercise
    
    var body: some View {
        HStack {




            
            // TODO: Add thumbnail image animating back and forth between the two images
            SafeImage(imageName: exercise.imageURLs[0])
                        .frame(width: 50, height: 50)

            Text(exercise.name)
            Spacer()

            
        }
    }
}

struct SafeImage: View {
    let imageName: String
    var body: some View {
        if UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
        } else {
            Image(systemName: "figure.run.circle.fill")
                .resizable()
        }
    }
}


#Preview {
    Group {
        ExerciseRowView(exercise: exercises[0])
        ExerciseRowView(exercise: exercises[4])
        
    }
    
}


