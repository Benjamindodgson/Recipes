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
        // Given: A test image, URL, and service instance
        let service = ImageCacheService.mock()
        let testImage = Image(systemName: "star.fill")
        let testURL = URL(string: "https://example.com/test.jpg")!
        
        // When: Initially cache should be empty
        let initialValue = await service.getValue(for: testURL)
        #expect(initialValue == nil, "Cache should be empty at start")
        
        // And: Adding an image to cache
        await service.setValue(testImage, for: testURL)
        
        // Then: Image should be retrievable from cache
        let cachedValue = await service.getValue(for: testURL)
        #expect(cachedValue != nil, "Image should be stored in cache")
    }
    
    @Test
    func testImageRemoval() async throws {
        // Given: A test image, URL, and service instance
        let service = ImageCacheService.mock()
        let testImage = Image(systemName: "star.fill")
        let testURL = URL(string: "https://example.com/test.jpg")!
        
        // And: An image in cache
        await service.setValue(testImage, for: testURL)
        let initialValue = await service.getValue(for: testURL)
        #expect(initialValue != nil, "Image should be stored in cache")
        
        // When: Removing image from cache
        await service.setValue(nil, for: testURL)
        
        // Then: Cache should be empty
        let finalValue = await service.getValue(for: testURL)
        #expect(finalValue == nil, "Cache should be empty after removal")
    }
    
    @Test
    func testImageOverwrite() async throws {
        // Given: A test URL, images, and service instance
        let service = ImageCacheService.mock()
        let testURL = URL(string: "https://example.com/test.jpg")!
        let initialImage = Image(systemName: "circle.fill")
        let newImage = Image(systemName: "star.fill")
        
        // And: An initial image in cache
        await service.setValue(initialImage, for: testURL)
        let initialValue = await service.getValue(for: testURL)
        #expect(initialValue != nil, "Initial image should be stored in cache")
        
        // When: Overwriting with new image
        await service.setValue(newImage, for: testURL)
        
        // Then: New image should be in cache
        let finalValue = await service.getValue(for: testURL)
        #expect(finalValue != nil, "New image should be stored in cache")
    }
    
    @Test
    func testCacheReset() async throws {
        // Given: A service instance with some cached images
        let service = ImageCacheService.mock()
        let testImage = Image(systemName: "star.fill")
        let testURL = URL(string: "https://example.com/test.jpg")!
        
        await service.setValue(testImage, for: testURL)
        let initialValue = await service.getValue(for: testURL)
        #expect(initialValue != nil, "Image should be stored in cache")
        
        // When: Resetting the cache
        await service.reset()
        
        // Then: Cache should be empty
        let finalValue = await service.getValue(for: testURL)
        #expect(finalValue == nil, "Cache should be empty after reset")
    }
}

