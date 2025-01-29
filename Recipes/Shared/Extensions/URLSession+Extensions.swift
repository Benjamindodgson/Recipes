//
//  URLSession+Extensions.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import Foundation

extension URLSession: Mockable {
    static func mock() -> Self {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration) as! Self
    }
}
