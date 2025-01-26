import SwiftUI

struct RecipeImageView: View {
    let url: URL
    let imageCacheService: ImageCacheService
    
    @State private var image: Image?
    @State private var isLoading = false
    @State private var error: ImageCacheError?
    
    var body: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                ProgressView()
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .task {
            isLoading = true
            let result = await imageCacheService.fetchImage(for: url)
            isLoading = false
            
            switch result {
            case .success(let loadedImage):
                image = loadedImage
            case .failure(let loadError):
                error = loadError
            }
        }
    }
} 