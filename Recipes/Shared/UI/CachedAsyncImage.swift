//
//  CachedAsyncImage.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import SwiftUI

/// A SwiftUI view that asynchronously loads and caches images from a remote URL.
struct CachedAsyncImageViewView<Content>: View, Loggable where Content: View {
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(url: URL,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         content: @escaping (AsyncImagePhase) -> Content) {
        
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let image = ImageCacheService[url] {
            renderCached(image: image)
        } else {
            AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                // Handle the different loading states using the content closure
                renderImage(for: phase)
            }
        }
    }
    
    private func renderCached(image: Image) -> some View {
        // Log or handle cached image logic
        logger.info("Cache hit for URL: \(url.absoluteString, privacy: .public)")
        return content(.success(image))
    }
    
    private func renderImage(for phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            logger.info("Image cached successfully for URL: \(url.absoluteString, privacy: .public)")
            ImageCacheService[url] = image
        }
        
        return content(phase)
    }
}
