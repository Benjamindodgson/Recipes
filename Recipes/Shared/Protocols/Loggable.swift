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

extension Logger {
    func info(_ message: String) {
        self.log(level: .info, "✅ \(message)")
    }
    
    func debug(_ message: String) {
        self.log(level: .debug, "🔍 \(message)")
    }
    
    func warning(_ message: String) {
        self.log(level: .default, "⚠️ \(message)")
    }
    
    func error(_ message: String) {
        self.log(level: .error, "❌ \(message)")
    }
    
    func fault(_ message: String) {
        self.log(level: .fault, "💥 \(message)")
    }
}

