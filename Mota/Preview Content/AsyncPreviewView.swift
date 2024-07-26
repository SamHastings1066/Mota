//
//  AsyncPreviewView.swift
//  Mota
//
//  Created by sam hastings on 25/07/2024.
//

import SwiftUI

//protocol AsyncSetup: Sendable {
//    func performSetup() async
//}
//
//struct AsyncPreviewView<Content: View, Setup: AsyncSetup>: View {
//    @State private var isLoading = true
//    var setup: Setup
//    var content: () -> Content
//    
//    var body: some View {
//        if isLoading {
//            ProgressView("Loading...")
//                .task {
//                    await setup.performSetup()
//                    isLoading = false
//                }
//        } else {
//            content()
//        }
//    }
//}

struct AsyncPreviewView<Content: View>: View {
    @State private var isLoading = true
    @State private var additionalState: UUID?
    var asyncTasks: () async -> UUID?
    @ViewBuilder var content: (UUID?) -> Content

    var body: some View {
        if isLoading {
            ProgressView("Loading...")
                .task {
                    additionalState = await asyncTasks()
                    isLoading = false
                }
        } else {
            content(additionalState)
        }
    }
}
