//
//  ImageCacheService.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import SwiftUI
import OSLog

protocol ImageCacheServiceProtocol: Serviceable {
    static subscript (key: URL) -> Image? { get set }
}

/// A service that handles loading and caching of images in a thread-safe manner
actor ImageCacheService: ImageCacheServiceProtocol {
    
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

extension ImageCacheService {
    
    static func mock() -> Self {
        .init()
    }
}
