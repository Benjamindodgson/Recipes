import SwiftUI

struct ImageView: View {
    let viewModel: ImageViewModel
    
    var body: some View {
        Group {
            if let image = viewModel.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .task {
            await viewModel.loadImage()
        }
    }
} 