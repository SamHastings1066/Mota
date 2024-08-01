//
//  AsyncPreviewView.swift
//  Mota
//
//  Created by sam hastings on 25/07/2024.
//

import SwiftUI


struct AsyncPreviewView<Content: View>: View {
    @State private var isLoading = true
    @State private var workout: WorkoutNew?
    var asyncTasks: () async -> WorkoutNew?
    @ViewBuilder var content: (WorkoutNew?) -> Content

    var body: some View {
        if isLoading {
            ProgressView("Loading...")
                .task {
                    workout = await asyncTasks()
                    isLoading = false
                }
        } else {
            content(workout)
        }
    }
}
