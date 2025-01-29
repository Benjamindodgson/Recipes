//
//  Mockable.swift
//  Recipes
//
//  Created by YourName on 1/29/25.
//

/// A protocol that provides a convenient way to generate mock instances of conforming types.
///
/// `Mockable` is particularly useful for SwiftUI previews and lightweight testing.
/// By defining a static `mock()` method, you can easily create placeholder data 
/// without cluttering your actual business logic.
///
/// ## Example Usage
/// ```swift
/// struct User: Mockable {
///     let id: String
///     let name: String
///
///     static func mock() -> User {
///         // Return a mock instance of `User`
///         return User(id: "mock-id", name: "Mock User")
///     }
/// }
///
/// // Usage in a SwiftUI Preview
/// struct UserView_Previews: PreviewProvider {
///     static var previews: some View {
///         UserView(user: .mock())
///     }
/// }
/// ```
///
/// Conforming to `Mockable` allows you to:
/// - Quickly generate sample data for SwiftUI previews.
/// - Avoid dependency on real data sources during development.
/// - Simplify tests by keeping all mock logic in one place.
protocol Mockable {
    /// Creates and returns a mock instance of the conforming type.
    ///
    /// - Returns: A mock instance with placeholder values for development and testing.
    static func mock() -> Self
}
