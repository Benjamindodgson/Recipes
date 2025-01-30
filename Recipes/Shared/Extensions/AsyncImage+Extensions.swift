//
//  AsyncImage+Extensions.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import SwiftUI
import OSLog

extension AsyncImage where Content: View {
    /// Creates an AsyncImage instance from an ImageDisplayable object
    /// - Parameters:
    ///   - displayable: The ImageDisplayable object containing the image configuration
    ///   - content: A closure that takes an AsyncImagePhase and returns a view
    /// - Returns: An AsyncImage configured with the displayable's properties
    init(displayable: ImageDisplayable,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        
        self.init(url: displayable.url,
                  scale: displayable.scale,
                  transaction: displayable.transaction,
                  content: content
        )
    }
}
