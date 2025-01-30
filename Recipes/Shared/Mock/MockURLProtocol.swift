//
//  MockURLProtocol.swift
//  Recipes
//
//  Created by Benjamin Dodgson on 1/29/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = self.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let data = self.mockData {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = self.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
