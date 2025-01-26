//
//  RecipeRowView.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    // Constants for layout
    private enum Layout {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let gradientHeight: CGFloat = 80
    }
    
    var body: some View {
        // Main card container
        VStack(spacing: 0) {
            // Recipe image at the top
            RecipeImageView(recipe: recipe)
                .frame(height: 200)
            
            // Text overlay with gradient background
            textOverlay
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .shadow(radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Private Views
    
    private var textOverlay: some View {
        ZStack(alignment: .bottom) {
            // Gradient background for text
            LinearGradient(
                colors: [
                    .black.opacity(0.5),
                    .black.opacity(0.2)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: Layout.gradientHeight)
            
            // Recipe information
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Layout.padding)
        }
    }
}
