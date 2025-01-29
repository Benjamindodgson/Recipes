//
//  RecipeListView.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import SwiftUI

struct RecipesView: View {
    let viewModel: RecipesViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading recipes...")
                case .error(let error):
                    ContentUnavailableView("Error",
                                           systemImage: "exclamationmark.triangle",
                                           description: Text(error.localizedDescription)
                    )
                case .empty:
                    ContentUnavailableView("No Recipes",
                                           systemImage: "fork.knife",
                                           description: Text("No recipes found")
                    )
                case .loaded(let recipes):
                    recipeList(recipes: recipes)
                case .idle:
                    // Show nothing until loading starts
                    EmptyView()
                }
            }
            .navigationTitle("Recipes")
        }
        .task {
            await viewModel.loadRecipes()
        }
    }
    
    private func recipeList(recipes: [Recipe]) -> some View {
        RecipesScrollView(recipes: recipes)
    }
}

private struct RecipesScrollView: View {
    let recipes: [Recipe]
    private let horizontalPadding: CGFloat = 30 // Define padding as a property
    
    @State private var selectedIndex: Int? = nil    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Array(recipes.enumerated()), id: \.element.id) { index, recipe in
                    GeometryReader { geometry in
                        RecipeCardView(recipe: recipe)
                            .frame(height: geometry.size.height * 0.4) // 40% of the scroll view's height
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.9)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                    .blur(radius: phase.isIdentity ? 0 : 1)
                            }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.4) // Ensure each card takes 40% of the screen height
                }
            }
            .padding(.horizontal, horizontalPadding) // Use property for padding
            .padding(.vertical, 100)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $selectedIndex)
    }
}

#Preview {
    RecipesView(viewModel: RecipesViewModel.mock())
} 
