//
//  ImageCacheService.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import SwiftUI
import OSLog

protocol ImageCacheServiceProtocol: Serviceable {
    func reset()
    func getValue(for key: URL) -> Image?
    func setValue(_ value: Image?, for key: URL)
}

/// A service that handles loading and caching of images in a thread-safe manner
actor ImageCacheService: ImageCacheServiceProtocol {
    private var cache: [URL: Image] = [:]
    
    func reset() {
        cache.removeAll()
    }
    
    func getValue(for key: URL) -> Image? {
        cache[key]
    }
    
    func setValue(_ value: Image?, for key: URL) {
        cache[key] = value
    }
}

extension ImageCacheService {
    
    static func mock() -> Self {
        .init()
    }
}
