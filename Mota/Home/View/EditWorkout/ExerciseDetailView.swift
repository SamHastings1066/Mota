//
//  ExerciseDetailView.swift
//  Mota
//
//  Created by sam hastings on 31/01/2024.
//

import SwiftUI

struct ExerciseDetailView: View {
    
    @Binding var isVisible: Bool
    
    var body: some View {
        Text("Exercise detail!")
            //.navigationTitle("Exercise detail")
        Button("Dismiss", action: { isVisible.toggle() })
    }
}

#Preview {
    ExerciseDetailView(isVisible: .constant(true))
}
