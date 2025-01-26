import SwiftUI
import OSLog

/// A service that handles loading and caching of images in a thread-safe manner
actor ImageCacheService: Serviceable {
    
    static private var cache: [URL: Image] = [:]
    
    static subscript (key: URL) -> Image? {
        get {
            cache[key]
        } set {
            if let newValue = newValue {
                cache[key] = newValue
            } else {
                cache.removeValue(forKey: key)
            }
        }
    }
} 
