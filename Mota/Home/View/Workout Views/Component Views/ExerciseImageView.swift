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
            ExerciseDetailView(exercise: exercise)
        }

       
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutNew.self, configurations: config)
        return ExerciseImageView(exercise: DatabaseExercise.sampleExercises[0])
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }

}
