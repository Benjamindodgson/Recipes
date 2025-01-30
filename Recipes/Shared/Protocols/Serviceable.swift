//
//  Service.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

/// A protocol that defines the base requirements for all services in the app.
/// Services are actors that handle business logic and data operations.
///
/// Example usage:
/// ```swift
/// actor RecipeService: Serviceable {
///     func fetchRecipes() async throws -> [Recipe] {
///         log(.info, "Fetching recipes")
///         // Implementation
///     }
/// }
/// ```
protocol Serviceable: Actor, Loggable, Mockable { }
