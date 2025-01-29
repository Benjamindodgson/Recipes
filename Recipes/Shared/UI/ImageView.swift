//
//  ImageView.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import SwiftUI

@Observable
final class ImageViewModel: ViewModelable {
    
}

extension ImageViewModel {
    static func mock() -> Self {
        .init()
    }
}

/// A SwiftUI view that asynchronously loads and caches images from a remote URL.
struct ImageView<Content>: View, Loggable where Content: View {
    
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    enum AsyncImageError: Error {
        case invalidURL
    }
    
    init(urlString: String?,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        
        if let urlString, let url = URL(string: urlString) {
            self.url = url
        } else {
            self.url = nil
        }
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        Group {
            if let url {
                if let image = ImageCacheService[url] {
                    renderCached(image: image, url: url)
                } else {
                    AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                        renderImage(for: phase, url: url)
                    }
                }
            } else {
                content(.failure(AsyncImageError.invalidURL))
            }
        }
    }
    
    private func renderCached(image: Image, url: URL) -> some View {
        // Log or handle cached image logic
        logger.info("Cache hit for URL: \(url.absoluteString)")
        return content(.success(image))
    }
    
    private func renderImage(for phase: AsyncImagePhase, url: URL) -> some View {
        if case .success(let image) = phase {
            logger.info("Image cached successfully for URL: \(url.absoluteString)")
            ImageCacheService[url] = image
        }
        
        return content(phase)
    }
}
