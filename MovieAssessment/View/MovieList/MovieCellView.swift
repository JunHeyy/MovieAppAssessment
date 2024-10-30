import SwiftUI

struct MovieCell: View {
    var movie: Movie
    let cornerRadius = 10.0
    let imageMaxHeight = 300.0
    let blackRectangleMaxHeight = 40.0
    let blackRectangleOpacity = 0.7
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: movie.poster)) { phase in
                switch phase {
                case .empty:
                    ProgressView() // Loading indicator while the image is loading
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: imageMaxHeight)
                        .cornerRadius(cornerRadius)
                case .failure(_):
                    // Image failed to load, show a box with a cross
                    VStack {
                        Rectangle()
                            .fill(Color.gray) // Background color for the box
                            .frame(maxWidth: .infinity, maxHeight: imageMaxHeight)
                            .cornerRadius(cornerRadius)
                            .overlay(
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40) // Cross size
                                    .foregroundColor(.red) // Cross color
                            )
                    }
                @unknown default:
                    EmptyView() // Handle any unexpected case
                }
            }
            
            // Black overlay at the bottom
            Rectangle()
                .fill(Color.black.opacity(blackRectangleOpacity))
                .frame(maxWidth: .infinity, maxHeight: blackRectangleMaxHeight)
                .padding(.bottom, 0)
                .cornerRadius(cornerRadius)
            
            // Movie title text
            Text(formatTitle(movie.title))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(4)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func formatTitle(_ title: String) -> String {
        if let range = title.range(of: ":") {
            let beforeColon = title[..<range.lowerBound]
            let afterColon = title[range.upperBound...].trimmingCharacters(in: .whitespaces)
            let truncatedAfterColon: String
            if afterColon.count > 20 {
                truncatedAfterColon = ".."
            } else {
                truncatedAfterColon = afterColon
            }
            return "\(beforeColon):\n\(truncatedAfterColon)"
        }
        return title
    }
}
