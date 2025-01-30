//
//  MockURLProtocol.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    nonisolated(unsafe) static var mockData: Data?
    nonisolated(unsafe) static var mockResponse: URLResponse?
    nonisolated(unsafe) static var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let data = MockURLProtocol.mockData {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = MockURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
