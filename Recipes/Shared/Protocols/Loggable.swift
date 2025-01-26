//
//  Loggable.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/26/25.
//

import os

protocol Loggable {
    var logger: Logger { get }
}

extension Loggable {
    var logger: Logger {
        let category = String(describing: Self.self)
        return Logger(subsystem: "com.recipes.app", category: category)
    }
}
