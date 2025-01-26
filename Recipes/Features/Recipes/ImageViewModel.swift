import SwiftUI
import OSLog

@Observable final class ImageViewModel {
    private let logger = Logger(subsystem: "com.recipes.app", category: "ImageViewModel")
    
    // MARK: - Properties
    
    let url: URL
    let imageCacheService: ImageCacheService
    
    var image: Image?
    var isLoading = false
    var error: ImageCacheError?
    
    // MARK: - Initialization
    
    init(url: URL, imageCacheService: ImageCacheService) {
        self.url = url
        self.imageCacheService = imageCacheService
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func loadImage() async {
        logger.debug("Loading image from URL: \(self.url)")
        isLoading = true
        let result = await imageCacheService.fetchImage(for: url)
        isLoading = false
        
        switch result {
        case .success(let loadedImage):
            logger.debug("Successfully loaded image")
            image = loadedImage
        case .failure(let loadError):
            logger.error("Failed to load image: \(loadError)")
            error = loadError
        }
    }
} 
