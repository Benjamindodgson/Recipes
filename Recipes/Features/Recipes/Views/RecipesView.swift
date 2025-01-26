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
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(recipes) { recipe in
                    RecipeCardView(recipe: recipe)
                        .frame(width: 300) // Fixed width for cards
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                .blur(radius: phase.isIdentity ? 0 : 2)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}

#Preview {
    RecipesView(viewModel: RecipesViewModel())
} 
