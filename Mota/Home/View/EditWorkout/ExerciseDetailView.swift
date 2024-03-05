//
//  ExerciseDetailView.swift
//  Mota
//
//  Created by sam hastings on 31/01/2024.
//

import SwiftUI

struct ExerciseDetailView: View {
    var exercise: Exercise?
    
    
    
    var imageNames: [String?] {
        if let databaseExercise = exercise as? DatabaseExercise, !databaseExercise.imageURLs.isEmpty {
            return [databaseExercise.imageURLs[0], databaseExercise.imageURLs[1]]
        } else {
            return [nil,nil]
        }
    }
    
    var body: some View {
        if let exercise = exercise as? DatabaseExercise {
            Text("\(exercise.name)")
                .font(.title)
            exerciseAnimationView(imageNames: imageNames)
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
    ExerciseDetailView(exercise: exercises[0])
}

struct exerciseAnimationView: View {
    var imageNames: [String?]
    @State private var showFirstImage = true
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Group {
            if showFirstImage {
                SafeImage(imageName: imageNames[0])
                    .transition(.opacity)
            } else {
                SafeImage(imageName: imageNames[1])
                    .transition(.opacity)
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showFirstImage.toggle()
            }
        }
    }
}
