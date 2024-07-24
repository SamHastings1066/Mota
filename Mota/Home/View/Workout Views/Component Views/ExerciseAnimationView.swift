//
//  ExerciseAnimationView.swift
//  Mota
//
//  Created by sam hastings on 24/07/2024.
//

import SwiftUI

struct ExerciseAnimationView: View {
    var imageNames: [String?]
    var fullSizeImageURLs: [String?]
    @State private var showFirstImage = true
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Group {
            if showFirstImage {
                SafeImageView(imageName: imageNames[0], fullSizeImageURL: fullSizeImageURLs[0])
                    .transition(.opacity)
            } else {
                SafeImageView(imageName: imageNames[1], fullSizeImageURL: fullSizeImageURLs[1])
                    .transition(.opacity)
            }
        }
        .onReceive(timer) { _ in
            //withAnimation(.easeInOut(duration: 0.5)) {
                self.showFirstImage.toggle()
            //}
        }
    }
}

//#Preview {
//    ExerciseAnimationView()
//}
