//
//  ExerciseDetailView.swift
//  Mota
//
//  Created by sam hastings on 31/01/2024.
//

import SwiftUI

struct ExerciseDetailView: View {
    
    @Binding var isVisible: Bool
    var exercise: Exercise?
    
    var body: some View {
        if let exercise = exercise {
            Text("\(exercise.name) info!")
        } else {
            Text("No info!")
        }
        
            //.navigationTitle("Exercise detail")
        Button("Dismiss", action: { isVisible.toggle() })
    }
}

#Preview {
    ExerciseDetailView(isVisible: .constant(true), exercise: exercises[0])
}
