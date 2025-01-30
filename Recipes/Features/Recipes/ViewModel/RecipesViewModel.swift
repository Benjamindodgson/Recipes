//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import Foundation
import SwiftUI

/// RecipesViewModel handles the business logic for displaying and managing recipes
/// 
/// Example usage:
/// ```
/// let viewModel = RecipesViewModel()
/// await viewModel.loadRecipes()
/// switch viewModel.state {
///     case .loaded(let recipes):
///         // Handle loaded recipes
///     case .error(let error):
///         // Handle error
///     // ... handle other cases
/// }
/// ```
@Observable
final class RecipesViewModel: ViewModelable {
    private let service: RecipeServiceProtocol
    
    /// Represents the current state of recipe loading
    public enum LoadingState {
        case idle
        case loading
        case loaded([Recipe])
        case empty
        case error(Error)
    }
    
    /// The current loading state of the recipes
    var state: LoadingState = .idle {
        didSet {
            logger.debug("State changed from \(oldValue) to \(state)")
        }
    }
    
    init(service: RecipeServiceProtocol = RecipeService()) {
        self.service = service
    }
    
    /// Loads recipes from the recipe service
    /// - Throws: Any error that occurs during the recipe fetching process
    @MainActor
    func loadRecipes() async {
        logger.debug("Starting recipe loading process")
        state = .loading
        
        do {
            logger.debug("Fetching recipes from service")
            let recipes = try await service.fetchRecipes()
            
            if recipes.isEmpty {
                logger.warning("Recipe fetch completed but no recipes were found")
                state = .empty
            } else {
                logger.info("Successfully loaded \(recipes.count) recipes")
                state = .loaded(recipes)
            }
        } catch {
            logger.error("Failed to load recipes with error: \(error.localizedDescription)")
            logger.debug("Detailed error: \(String(describing: error))")
            state = .error(error)
        }
    }
}

// MARK: - Mocking
extension RecipesViewModel {
    /// Creates a mock instance of RecipesViewModel for testing
    /// - Returns: A mock instance of RecipesViewModel
    static func mock() -> Self {
        .init(service: MockRecipeService())
    }
}
