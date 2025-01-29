//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import Foundation
import SwiftUI

@Observable
final class RecipesViewModel: ViewModelable {
    private let service: RecipeServiceProtocol
    
    enum LoadingState {
        case idle
        case loading
        case loaded([Recipe])
        case empty
        case error(Error)
    }
    
    var state: LoadingState = .idle
    
    init(service: RecipeServiceProtocol = RecipeService()) {
        self.service = service
    }
    
    /// Description
    @MainActor
    func loadRecipes() async {
        logger.debug("Loading recipes...")
        state = .loading
        
        do {
            let recipes = try await service.fetchRecipes()
            
            if recipes.isEmpty {
                logger.warning("No recipes found")
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

extension RecipesViewModel {
    static func mock() -> Self {
        .init(service: RecipeService.mock())
    }
}
