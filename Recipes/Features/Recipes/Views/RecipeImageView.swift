//
//  RecipeImageView.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import SwiftUI

/// A view that displays an image for a given recipe using `CachedAsyncImage`.
struct RecipeImageView: View {
    
    let recipe: Recipe
    
    var body: some View {
        CachedAsyncImageView(urlString: recipe.photoURLLarge) { phase in
            switch phase {
            case .empty:
                placeholderView
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                errorView
            @unknown default:
                errorView
            }
        }
        //.frame(width: 200, height: 200) // Adjust frame as needed
        .clipShape(RoundedRectangle(cornerRadius: 10)) // Optional styling
        .shadow(radius: 5) // Optional styling
    }
    
    /// A placeholder view shown while the image is loading.
    private var placeholderView: some View {
        ZStack {
            Color.gray.opacity(0.2)
            ProgressView()
        }
    }
    
    /// A view shown when the image fails to load.
    private var errorView: some View {
        ZStack {
            Color.red.opacity(0.2)
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
        }
    }
}
