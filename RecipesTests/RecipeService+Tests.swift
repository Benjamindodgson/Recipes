//
//  RecipeService+Tests.swift
//  RecipesTest
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import Testing
import Foundation

@testable import Recipes

struct RecipeServiceTests {
    
    // MARK: - Test Setup
    
    func makeService() -> RecipeService {
        let session = URLSession.mock()
        return RecipeService(session: session)
    }
    
    func mockSuccessResponse() -> (Data, URLResponse) {
        let recipes = [
            Recipe(cuisine: "Italian",
                  name: "Pizza",
                  photoURLLarge: "https://example.com/large.jpg",
                  photoURLSmall: "https://example.com/small.jpg",
                  uuid: "123",
                  sourceURL: "https://example.com/recipe",
                  youtubeURL: "https://youtube.com/watch")
        ]
        let response = RecipeResponse(recipes: recipes)
        let data = try! JSONEncoder().encode(response)
        let httpResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                         statusCode: 200,
                                         httpVersion: nil,
                                         headerFields: nil)!
        return (data, httpResponse)
    }
    
    // MARK: - Tests
    
    @Test
    func testFetchRecipesSuccess() async throws {
        // Given
        let service = makeService()
        let (data, response) = mockSuccessResponse()
        MockURLProtocol.mockData = data
        MockURLProtocol.mockResponse = response
        
        // When
        let recipes = try await service.fetchRecipes()
        
        // Then
        #expect(recipes.count == 1)
        #expect(recipes[0].name == "Pizza")
        #expect(recipes[0].cuisine == "Italian")
    }
    
    @Test
    func testFetchRecipesInvalidURL() async {
        // Given
        let service = makeService()
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = nil
        
        // When/Then
        do {
            _ = try await service.fetchRecipes()
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
            if case NetworkError.invalidURL = error {
                // Success
            } else {
                #expect(Bool(false), "Wrong error type: \(error)")
            }
        }
    }
    
    @Test
    func testFetchRecipesBadStatusCode() async {
        // Given
        let service = makeService()
        let httpResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                         statusCode: 404,
                                         httpVersion: nil,
                                         headerFields: nil)!
        MockURLProtocol.mockResponse = httpResponse
        
        // When/Then
        do {
            _ = try await service.fetchRecipes()
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
            if case NetworkError.badStatus(let code) = error {
                #expect(code == 404)
            } else {
                #expect(Bool(false), "Wrong error type: \(error)")
            }
        }
    }
    
    @Test
    func testFetchRecipesDecodingError() async {
        // Given
        let service = makeService()
        let invalidJSON = "invalid json".data(using: .utf8)!
        let httpResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                         statusCode: 200,
                                         httpVersion: nil,
                                         headerFields: nil)!
        MockURLProtocol.mockData = invalidJSON
        MockURLProtocol.mockResponse = httpResponse
        
        // When/Then
        do {
            _ = try await service.fetchRecipes()
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
            if case NetworkError.decodingError = error {
                // Success
            } else {
                #expect(Bool(false), "Wrong error type: \(error)")
            }
        }
    }
}

// MARK: - Private Helpers

private struct RecipeResponse: Encodable {
    let recipes: [Recipe]
}

