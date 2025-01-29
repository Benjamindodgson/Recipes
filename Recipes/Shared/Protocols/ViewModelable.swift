//
//  ViewModelable.swift
//  Recipes
//
//
//  ViewModelable.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

/// A protocol that defines a basic contract for ViewModels in the application.
///
/// `ViewModelable` establishes a lightweight foundation for all ViewModels by:
/// - Ensuring conformance to `Identifiable`, requiring a unique identifier.
/// - Incorporating `Loggable` for structured logging capabilities.
///
/// This protocol is particularly useful in an MVVM (Model-View-ViewModel) architecture,
/// where consistent data structures and logging are essential.
///
/// ## Example Usage
///
/// ```swift
/// struct RecipesViewModel: ViewModelable {
///     let id: UUID
/// }
///
/// let viewModel = RecipesViewModel(id: UUID())
/// print(viewModel.id) // Outputs the unique identifier for this ViewModel.
/// ```
///
/// ## Key Benefits
/// - **Ensures Uniqueness**: Each ViewModel has an `id`, making it compatible with SwiftUI’s `List` and `ForEach`.
/// - **Improves Maintainability**: Standardizes ViewModel structure across the app.
/// - **Facilitates Debugging**: Provides logging capabilities via `Loggable`.
///
/// ## Use Cases
/// - Structuring ViewModels in SwiftUI-based applications.
/// - Enforcing a common API for all ViewModels.
/// - Enhancing traceability with built-in logging.
///
/// Adopting `ViewModelable` ensures a unified and scalable ViewModel design throughout the application.
protocol ViewModelable: Identifiable, Loggable, Mockable {}
