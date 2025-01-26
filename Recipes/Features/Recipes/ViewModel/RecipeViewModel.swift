//
//  RecipeViewModel.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import Foundation
import SwiftUI

@Observable final class RecipeViewModel {
    private let recipeService: RecipeService
    
    enum LoadingState {
        case idle
        case loading
        case loaded([Recipe])
        case empty
        case error(Error)
    }
    
    var state: LoadingState = .idle
    
    init(recipeService: RecipeService = RecipeService()) {
        self.recipeService = recipeService
        print("📱 RecipeViewModel initialized")
    }
    
    @MainActor
    func loadRecipes() async {
        print("📱 Loading recipes...")
        state = .loading
        
        do {
            let recipes = try await recipeService.fetchRecipes()
            
            if recipes.isEmpty {
                print("📱 No recipes found")
                state = .empty
            } else {
                print("📱 Loaded \(recipes.count) recipes")
                state = .loaded(recipes)
            }
        } catch {
            print("❌ Error loading recipes: \(error)")
            state = .error(error)
        }
    }
} 
