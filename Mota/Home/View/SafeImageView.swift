//
//  SafeImageView.swift
//  Mota
//
//  Created by sam hastings on 28/03/2024.
//

import SwiftUI

struct SafeImageView: View {
    let imageName: String?
    let fullSizeImageURL: URL?
    var imageLoader = ImageLoader()
    
    var body: some View {
        AsyncImage(url: fullSizeImageURL) { phase in
            switch phase {
            case .empty:
                thumbnailImage
            case .success:
                if let image = phase.image {
                        image
                        .resizable()
                        .scaledToFit()
                } else {
                    thumbnailImage
                }
            case .failure:
                thumbnailImage
            @unknown default:
                placeholderImage
            }
            
        }
    }
    
    @ViewBuilder
    var thumbnailImage: some View {
        if let imageName = imageName, UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .scaledToFit()
        } else {
            placeholderImage
        }
    }
    
    var placeholderImage: some View {
        Image(systemName: "figure.run.circle.fill")
            .resizable()
            .scaledToFit()
    }
}

//#Preview {
//    SafeImageView()
//}
