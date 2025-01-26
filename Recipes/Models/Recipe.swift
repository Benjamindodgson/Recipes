/// A model representing a recipe with its associated metadata
struct Recipe: Identifiable, Codable {
    // MARK: - Properties
    
    /// The type of cuisine this recipe belongs to
    let cuisine: String
    
    /// The name of the recipe
    let name: String
    
    /// URL for the large photo of the recipe, if available
    let photoURLLarge: String?
    
    /// URL for the small photo of the recipe, if available
    let photoURLSmall: String?
    
    /// Unique identifier for the recipe
    let uuid: String
    
    /// Optional URL to the recipe's source
    let sourceURL: String?
    
    /// Optional URL to a YouTube video of the recipe
    let youtubeURL: String?
    
    /// Computed property to conform to Identifiable
    var id: String { uuid }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case uuid
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

// MARK: - Debug Support

extension Recipe: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        Recipe(
            name: \(name),
            cuisine: \(cuisine),
            uuid: \(uuid)
        )
        """
    }
} 