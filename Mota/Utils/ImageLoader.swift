//
//  ImageLoader.swift
//  Mota
//
//  Created by sam hastings on 28/03/2024.
//

import SwiftUI
import Combine

@Observable
class ImageLoader {
    var image: Image? = nil
    private var cancellable: AnyCancellable?

    func load(fromURL url: URL) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { UIImage(data: $0.data) }
            .map { $0.map(Image.init) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.image = $0 })
    }

    func cancel() {
        cancellable?.cancel()
    }
}
