import Foundation

/// Service responsible for fetching recipes from the remote API
actor RecipeService {
    private let session: URLSession
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    init(session: URLSession = .shared) {
        self.session = session
        print("🍳 RecipeService initialized")
    }
    
    /// Fetches recipes from the remote API
    /// - Returns: Array of Recipe objects
    /// - Throws: NetworkError if the request fails
    func fetchRecipes() async throws -> [Recipe] {
        print("🍳 Fetching recipes...")
        
        guard let url = URL(string: "\(baseURL)/recipes.json") else {
            print("❌ Invalid URL")
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Invalid response type")
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            print("❌ Bad status code: \(httpResponse.statusCode)")
            throw NetworkError.badStatus(httpResponse.statusCode)
        }
        
        do {
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            print("✅ Successfully fetched \(recipes.count) recipes")
            return recipes
        } catch {
            print("❌ Failed to decode recipes: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatus(Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .badStatus(let code):
            return "Bad status code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
} 