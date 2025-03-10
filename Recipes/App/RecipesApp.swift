//
//  RecipesApp.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/22/25.
//

import SwiftUI
import OSLog

@main
struct RecipesApp: App {

    var body: some Scene {
        WindowGroup {
            RecipesView(viewModel: RecipesViewModel())
        }
    }
}
