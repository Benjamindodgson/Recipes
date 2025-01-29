//
//  ImageCacheService+Tests.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import Testing
@testable import Recipes
import SwiftUI

struct ImageCacheServiceTests {
    
    @Test
    func testImageCaching() async throws {
        // Given: A test image and URL
        let testImage = Image(systemName: "star.fill")
        let testURL = URL(string: "https://example.com/test.jpg")!
        
        // Clear cache initially
        ImageCacheService[testURL] = nil
        
        // When: Initially cache should be empty
        #expect(ImageCacheService[testURL] == nil, "Cache should be empty at start")
        
        // And: Adding an image to cache
        ImageCacheService[testURL] = testImage
        
        // Then: Image should be retrievable from cache
        #expect(ImageCacheService[testURL] != nil, "Image should be stored in cache")
    }
    
    @Test
    func testImageRemoval() async throws {
        // Given: A test image and URL
        let testImage = Image(systemName: "star.fill")
        let testURL = URL(string: "https://example.com/test.jpg")!
        
        // And: An image in cache
        ImageCacheService[testURL] = testImage
        #expect(ImageCacheService[testURL] != nil, "Image should be stored in cache")
        
        // When: Removing image from cache
        ImageCacheService[testURL] = nil
        
        // Then: Cache should be empty
        #expect(ImageCacheService[testURL] == nil, "Cache should be empty after removal")
    }
    
    @Test
    func testImageOverwrite() async throws {
        // Given: A test URL and images
        let testURL = URL(string: "https://example.com/test.jpg")!
        let initialImage = Image(systemName: "circle.fill")
        let newImage = Image(systemName: "star.fill")
        
        // And: An initial image in cache
        ImageCacheService[testURL] = initialImage
        #expect(ImageCacheService[testURL] != nil, "Initial image should be stored in cache")
        
        // When: Overwriting with new image
        ImageCacheService[testURL] = newImage
        
        // Then: New image should be in cache
        #expect(ImageCacheService[testURL] != nil, "New image should be stored in cache")
    }
}

