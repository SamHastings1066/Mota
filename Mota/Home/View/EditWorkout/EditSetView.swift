//
//  EditSetView.swift
//  Mota
//
//  Created by sam hastings on 01/02/2024.
//

import SwiftUI

struct EditSetView: View {
    
    @State private var isShowingExerciseInfoSheet = false
    
    var body: some View {
        
        Button(action: {
            
        }) {
            Text("Add set")
        }
        
        Text("Edit set!")
        
            //.navigationTitle("Edit Set")
        Button(action: {
            isShowingExerciseInfoSheet.toggle()
        }) {
            Text("Exercise info")
        }
        .sheet(isPresented: $isShowingExerciseInfoSheet, onDismiss: didDismiss) {
        //.fullScreenCover(isPresented: $isShowingExerciseInfoSheet) {
            ExerciseDetailView(isVisible: $isShowingExerciseInfoSheet)
            
        }
        
        
    }
    
    func didDismiss() {
        // Handle the dismissing action.
    }
}

#Preview {
    EditSetView()
}
