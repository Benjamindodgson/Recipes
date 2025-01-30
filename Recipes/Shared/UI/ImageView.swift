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
    
    private let viewModel: ImageViewModel
    private let content: (AsyncImagePhase) -> Content
    
    init(displayable: ImageDisplayable,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.viewModel = ImageViewModel(displayable: displayable)
        self.content = content
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                content(.empty)
            case .loading(let url):
                AsyncImage(displayable: viewModel.displayable) { phase in
                    renderImage(for: phase, url: url)
                }
            case .loaded(let image):
                content(.success(image))
            case .error(let error):
                content(.failure(error))
            }
        }.task {
            await viewModel.loadImage()
        }
    }
    
    private func renderImage(for phase: AsyncImagePhase, url: URL) -> some View {
        switch phase {
        case .empty:
            logger.debug("Starting image load for URL: \(url.absoluteString)")
        case .success(let image):
            Task {
                logger.info("Image loaded successfully for URL: \(url.absoluteString)")
                logger.debug("Caching image in memory")
                await viewModel.cache(image: image, for: url)
            }
        case .failure(let error):
            logger.error("Image load failed for URL: \(url.absoluteString), error: \(error.localizedDescription)")
        @unknown default:
            logger.warning("Unknown AsyncImagePhase encountered")
        }
        
        return content(phase)
    }
}
