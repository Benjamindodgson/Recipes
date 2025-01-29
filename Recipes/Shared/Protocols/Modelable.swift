//
//  Modelable.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

/// A protocol that combines common functionality for models in the application.
///
/// `Modelable` is a protocol that enforces conformance to the following:
/// - `Identifiable`: Requires the type to have a unique identifier.
/// - `Codable`: Enables encoding and decoding of the type to and from data formats like JSON.
/// - `Equatable`: Allows instances of the type to be compared for equality.
///
/// Use `Modelable` for any model in your application that needs to be identifiable, serializable, and comparable.
///
/// ### Example Usage
/// ```swift
/// struct Recipe: Modelable {
///     let id: Int
///     let title: String
/// }
///
/// // Example of Codable functionality
/// let recipe = Recipe(id: 1, title: "Burger")
/// let data = try JSONEncoder().encode(recipe)
/// let decodedRecipe = try JSONDecoder().decode(Recipe.self, from: data)
///
/// // Example of Identifiable functionality
/// print(recipe.id) // Prints 1
///
/// // Example of Equatable functionality
/// let anotherRecipe = Recipe(id: 2, title: "BLT")
/// print(recipe == anotherRecipe) // Prints false
/// ```
protocol Modelable: Identifiable, Codable, Equatable, Loggable {}
