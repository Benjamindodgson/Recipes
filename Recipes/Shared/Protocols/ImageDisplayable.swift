//
//  ImageDisplayable.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import SwiftUI

/// A protocol that defines the requirements for displaying images in the app
///
/// Example usage:
/// ```swift
/// struct Recipe: ImageDisplayable {
///     let urlString: String
///     
///     // Other properties use default implementation
/// }
/// ```
protocol ImageDisplayable {
    /// The string representation of the image URL
    var urlString: String { get }
    
    /// The parsed URL from the urlString. Returns nil if the string is invalid
    var url: URL? { get }
    
    /// The scale factor to apply to the image. Defaults to 1
    var scale: CGFloat { get }
    
    /// The animation transaction for image loading. Defaults to empty transaction
    var transaction: Transaction { get }
    
    /// Validates if the URL string is properly formatted
    func validateURL() -> Result<URL, URLError>
}

extension ImageDisplayable {
    var url: URL? { URL(string: urlString) }
    var scale: CGFloat { 1 }
    var transaction: Transaction { Transaction() }
    
    func validateURL() -> Result<URL, URLError> {
        guard let url = self.url else {
            return .failure(URLError(.badURL))
        }
        return .success(url)
    }
}
