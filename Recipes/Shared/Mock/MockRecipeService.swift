//
//  MockRecipeService.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import Foundation

struct MockRecipes {
    /// Mock recipes with real image URLs
    static let recipes: [Recipe] = [
        .init(cuisine: "Italian",
              name: "Margherita Pizza",
              photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
              photoURLSmall: nil,
              uuid: "mock-1",
              sourceURL: nil,
              youtubeURL: nil),
        
        .init(cuisine: "Mexican",
              name: "Chicken Tacos",
              photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
              photoURLSmall: nil,
              uuid: "mock-2",
              sourceURL: nil,
              youtubeURL: nil),
        
        .init(cuisine: "American",
              name: "Classic Burger",
              photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
              photoURLSmall: nil,
              uuid: "mock-3",
              sourceURL: nil,
              youtubeURL: nil),
        
        .init(cuisine: "Japanese",
              name: "Sushi Roll",
              photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/large.jpg",
              photoURLSmall: nil,
              uuid: "mock-4",
              sourceURL: nil,
              youtubeURL: nil)
    ]
}

/// A mock implementation of RecipeServiceProtocol for testing and previews
actor MockRecipeService: RecipeServiceProtocol {
    
    /// Simulates fetching recipes from a remote API
    /// - Returns: Array of mock Recipe objects
    func fetchRecipes() async throws -> [Recipe] {
        logger.debug("Fetching mock recipes...")
        // Simulate network delay
        await performDelayedTask()
        logger.info("Successfully fetched \(MockRecipes.recipes.count) mock recipes")
        return MockRecipes.recipes
    }
    
    // Define an asynchronous function that performs a delayed task
    func performDelayedTask() async {
        // Create an instance of ContinuousClock
        let clock = ContinuousClock()

        // Calculate the deadline by adding a duration to the current instant
        let deadline = clock.now + .seconds(1)

        // Perform the delay using the clock's sleep method
        try? await clock.sleep(until: deadline)
    }
}

// MARK: - Mockable

extension MockRecipeService: Mockable {
    static func mock() -> Self {
        .init()
    }
}

