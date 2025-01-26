import Foundation

/// Service responsible for fetching recipes from the remote API
actor RecipeService: Loggable {
    private let session: URLSession
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    init(session: URLSession = .shared) {
        self.session = session
        logger.info("🍳 RecipeService initialized")
    }
    
    /// Fetches recipes from the remote API
    /// - Returns: Array of Recipe objects
    /// - Throws: NetworkError if the request fails
    func fetchRecipes() async throws -> [Recipe] {
        logger.info("🍳 Fetching recipes...")
        
        guard let url = URL(string: "\(baseURL)/recipes.json") else {
            logger.error("❌ Invalid URL")
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("❌ Invalid response type")
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("❌ Bad status code: \(httpResponse.statusCode)")
            throw NetworkError.badStatus(httpResponse.statusCode)
        }
        
        do {
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            logger.info("✅ Successfully fetched \(recipes.count) recipes")
            return recipes
        } catch {
            logger.error("❌ Failed to decode recipes: \(error.localizedDescription, privacy: .public)")
            throw NetworkError.decodingError(error)
        }
    }
}
