//
//  ImageViewModel.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import SwiftUI

/// ViewModel responsible for managing image loading and caching state.
///
/// Example usage:
/// ```swift
/// let viewModel = ImageViewModel(displayable: recipe)
/// ImageView(viewModel: viewModel)
/// ```
@Observable
final class ImageViewModel: ViewModelable {
    
    /// Errors associated with image loading and caching
    enum ImageErorr: Error {
        case invalidURL
    }
    
    /// Represents the various loading states for images
    enum State {
        case idle
        case loading(URL)
        case loaded(Image)
        case error(Error)
    }
    
    // MARK: - Properties
    
    /// The model object conforming to `ImageDisplayable`
    let displayable: ImageDisplayable
    
    /// The service used for caching and retrieving images
    private let service: ImageCacheServiceProtocol
    
    /// The current state of the image load process
    var state: State = .idle
        
    // MARK: - Initialization
    
    /**
     Initializes a new ImageViewModel.

     - Parameters:
        - displayable: The object conforming to `ImageDisplayable` whose image should be displayed.
        - service: The service responsible for caching and retrieving images. Defaults to `ImageCacheService`.
     */
    init(displayable: ImageDisplayable,
        service: ImageCacheServiceProtocol = ImageCacheService()) {
        self.displayable = displayable
        self.service = service
    }
    
    // MARK: - Methods
    
    /**
     Loads an image from the associated `displayable`'s URL.

     This method checks the cache first. If the image is not in the cache,   
     it sets the state to `.loading` and prepares to download the image.
     */
    @MainActor
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
    
    /**
     Caches the loaded image locally and updates the state.

     - Parameters:
       - image: The `Image` to cache.
       - url: The `URL` associated with the Image.
     */
    func cache(image: Image, for url: URL) async {
        logger.debug("Caching image for URL: \(url.absoluteString)")
        await self.service.setValue(image, for: url)
        self.state = .loaded(image)
    }
}

extension ImageViewModel {
    /**
     Creates a mock `ImageViewModel` for testing and preview purposes.
     */
    static func mock() -> ImageViewModel {
        return ImageViewModel(displayable: Recipe.mock())
    }
}

