import SwiftUI

struct StarRatingView: View {
    var rating: String
    
    var body: some View {
        HStack(spacing: 2) {
            if let starCount = Int(rating.prefix(1)) {
                ForEach(0..<starCount, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
