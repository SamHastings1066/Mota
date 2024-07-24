//
//  SafeImageView.swift
//  Mota
//
//  Created by sam hastings on 28/03/2024.
//

import SwiftUI

struct SafeImageView: View {
    let imageName: String?
    let fullSizeImageURL: String?
    //var imageLoader = ImageLoader()
    
    var body: some View {
        RemoteImage(url: fullSizeImageURL ?? "", imageName: imageName)
    }
    
    
}

struct RemoteImage: View {
    var imageLoader: ImageLoader
    let imageName: String?
    

    init(url: String, imageName: String?) {
        imageLoader = ImageLoader(url: url)
        self.imageName = imageName
    }

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
//                .scaledToFit()
//                .frame(maxWidth: .infinity)
        } else {
            thumbnailImage
                .frame(maxWidth: .infinity)
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
            .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    SafeImageView()
//}
