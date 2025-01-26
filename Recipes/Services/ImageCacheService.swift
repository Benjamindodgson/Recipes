import SwiftUI
import OSLog
import UIKit

enum ImageCacheError: Error {
    case invalidImageData
    case downloadFailed(Error)
}

/// A service that handles loading and caching of images in a thread-safe manner
actor ImageCacheService {
    private let logger = Logger(subsystem: "com.recipes.app", category: "ImageCacheService")
    
    // MARK: - Properties
    
    /// In-memory cache for quick access to recently used images
    private var cache: [URL: Image] = [:]
    
    // MARK: - Public Methods
    
    /// Loads an image either from cache or downloads it from the provided URL
    /// - Parameter url: The URL of the image to load
    /// - Returns: A Result containing either the loaded Image or an error
    func fetchImage(for url: URL) async -> Result<Image, ImageCacheError> {
        // Check in-memory cache first
        if let cachedImage = cache[url] {
            logger.debug("Found image in memory cache for URL: \(url)")
            return .success(cachedImage)
        }
        
        do {
            logger.debug("Downloading image from URL: \(url)")
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let uiImage = UIImage(data: data) else {
                logger.error("Failed to create UIImage from downloaded data")
                return .failure(.invalidImageData)
            }
            
            let image = Image(uiImage: uiImage)
            // Store in memory cache
            cache[url] = image
            
            logger.debug("Successfully cached image for URL: \(url)")
            return .success(image)
        } catch {
            logger.error("Failed to download image: \(error.localizedDescription)")
            return .failure(.downloadFailed(error))
        }
    }
    
    /// Clears the in-memory cache
    func clearCache() {
        logger.debug("Clearing image cache")
        cache.removeAll()
    }
} 
