//
//  ImageDisplayable.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import SwiftUI

protocol ImageDisplayable {
    var urlString: String { get }
    var url: URL? { get }
    var scale: CGFloat { get }
    var transaction: Transaction { get }
}

extension ImageDisplayable {
    var url: URL? { URL(string: urlString) }
    var scale: CGFloat { 1 }
    var transaction: Transaction { Transaction() }
}
