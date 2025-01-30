//
//  Loggable.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import os

/// A protocol that provides logging capabilities to conforming types.
/// 
/// Example usage:
/// ```swift
/// class RecipeService: Loggable {
///     func fetchRecipes() async throws -> [Recipe] {
///         logger.info("Fetching recipes...")
///         // ... implementation
///     }
/// }
/// ```
protocol Loggable {
    var logger: Logger { get }
}

extension Loggable {
    var logger: Logger {
        let category = String(describing: Self.self)
        return Logger(subsystem: "com.recipes.app", category: category)
    }
}

extension Logger {
    /// Logs an informational message with a checkmark emoji
    /// - Parameters:
    ///   - message: The message to log
    func info(_ message: String) {
        self.log(level: .info, "✅ \(message)")
    }
    
    /// Logs a debug message with a magnifying glass emoji
    /// - Parameters:
    ///   - message: The message to log
    func debug(_ message: String) {
        self.log(level: .debug, "🔍 \(message)")
    }
    
    /// Logs a warning message with a warning emoji
    /// - Parameters:
    ///   - message: The message to log
    func warning(_ message: String) {
        self.log(level: .default, "⚠️ \(message)")
    }
    
    /// Logs an error message with a cross emoji
    /// - Parameters:
    ///   - message: The message to log
    func error(_ message: String) {
        self.log(level: .error, "❌ \(message)")
    }
    
    /// Logs a fault message with an explosion emoji
    /// - Parameters:
    ///   - message: The message to log
    func fault(_ message: String) {
        self.log(level: .fault, "💥 \(message)")
    }
}

