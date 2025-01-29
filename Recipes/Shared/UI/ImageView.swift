//
//  ImageView.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import SwiftUI

/// A SwiftUI view that asynchronously loads and caches images from a remote URL.
/// 
/// Example usage:
/// ```swift
/// ImageView(displayable: recipe) { phase in
///     switch phase {
///     case .empty:
///         ProgressView()
///     case .success(let image):
///         image.resizable()
///     case .failure(let error):
///         ErrorView(error: error)
///     @unknown default:
///         EmptyView()
///     }
/// }
/// ``
struct ImageView<Content>: View, Loggable where Content: View {
    
    private let displayable: ImageDisplayable
    private let content: (AsyncImagePhase) -> Content
    
    enum AsyncImageError: Error {
        case invalidURL
    }
    
    init(displayable: ImageDisplayable,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        
        self.displayable = displayable
        self.content = content
    }
    
    var body: some View {
        Group {
            if let url = displayable.url {
                if let image = ImageCacheService[url] {
                    renderCached(image: image, url: url)
                } else {
                    AsyncImage(displayable: displayable) { phase in
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
        switch phase {
        case .empty:
            logger.debug("Starting image load for URL: \(url.absoluteString)")
        case .success(let image):
            logger.info("Image loaded successfully for URL: \(url.absoluteString)")
            logger.debug("Caching image in memory")
            ImageCacheService[url] = image
        case .failure(let error):
            logger.error("Image load failed for URL: \(url.absoluteString), error: \(error.localizedDescription)")
        @unknown default:
            logger.warning("Unknown AsyncImagePhase encountered")
        }
        
        return content(phase)
    }
}
