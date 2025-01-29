//
//  RecipeViewModel.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import Foundation
import SwiftUI

@Observable final class RecipeViewModel: Loggable {
    private let service: RecipeService
    
    enum LoadingState {
        case idle
        case loading
        case loaded([Recipe])
        case empty
        case error(Error)
    }
    
    var state: LoadingState = .idle
    
    init(recipeService: RecipeService = RecipeService()) {
        self.service = recipeService
        logger.info("RecipeViewModel initialized")
        print()
    }
    
    @MainActor
    func loadRecipes() async {
        logger.info("Loading recipes...")
        state = .loading
        
        do {
            let recipes = try await service.fetchRecipes()
            
            if recipes.isEmpty {
                logger.info("No recipes found")
                state = .empty
            } else {
                logger.info("Loaded \(recipes.count) recipes")
                state = .loaded(recipes)
            }
        } catch {
            logger.error("Error loading recipes: \(error)")
            state = .error(error)
        }
    }
} 
