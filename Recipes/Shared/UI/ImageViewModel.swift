//
//  ImageViewModel.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import SwiftUI

/// ViewModel responsible for managing image loading and caching state
/// 
/// Example usage:
/// ```swift
/// let viewModel = ImageViewModel(displayable: recipe)
/// ImageView(viewModel: viewModel)
/// ```
@Observable
final class ImageViewModel: ViewModelable {
    
    enum ImageErorr: Error {
        case invalidURL
    }
    
    enum State {
        case idle
        case loading(URL)
        case loaded(Image)
        case error(Error)
    }
    
    // MARK: - Properties
    
    let displayable: ImageDisplayable
    private let service: ImageCacheServiceProtocol
    
    var state: State = .idle
        
    // MARK: - Initialization
    
    init(displayable: ImageDisplayable, 
         service: ImageCacheServiceProtocol = ImageCacheService()) {
        self.displayable = displayable
        self.service = service
    }
    
    // MARK: - Methods
    
    func loadImage() async {
        guard let url = self.displayable.url else {
            self.state = .error(ImageErorr.invalidURL)
            return
        }
        
        // Check cache first
        if let image = await self.service.getValue(for: url) {
            logger.info("Cache hit for URL: \(url.absoluteString)")
            self.state = .loaded(image)
            return
        }
        
        // Start loading
        logger.debug("Starting image load for URL: \(url.absoluteString)")
        self.state = .loading(url)
    }
    
    func cache(image: Image, for url: URL) async {
        await self.service.setValue(image, for: url)
        self.state = .loaded(image)
    }
}

extension ImageViewModel {
    static func mock() -> ImageViewModel {
        return ImageViewModel(displayable: Recipe.mock())
    }
}

