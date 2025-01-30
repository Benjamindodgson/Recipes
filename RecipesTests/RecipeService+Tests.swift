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
    
    func setup() -> RecipeService {
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = nil
        MockURLProtocol.mockError = nil
        let session = URLSession.mock()
        return RecipeService(session: session)
    }
    
    func mockSuccessResponse() -> (Data, URLResponse) {
        let recipes = MockRecipes.recipes
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
        let service = setup()
        let (data, response) = mockSuccessResponse()
        MockURLProtocol.mockData = data
        MockURLProtocol.mockResponse = response
        
        // When
        let recipes = try await service.fetchRecipes()
        
        // Then
        #expect(recipes.count == MockRecipes.recipes.count)
        #expect(recipes[0].name == "Margherita Pizza")
        #expect(recipes[0].cuisine == "Italian")
    }
    
    @Test
    func testFetchRecipesInvalidURL() async {
        // Given
        let service = setup()
        
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
    
    @Test
    func testFetchRecipesBadStatusCode() async {
        // Given
        let service = setup()
        let httpResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: nil)!
        MockURLProtocol.mockResponse = httpResponse
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockError = nil
        
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
        let service = setup()
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

