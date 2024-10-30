import SwiftUI
struct RatingBoxView: View {
    var source: String
    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(source)
                .font(.subheadline)
                .foregroundColor(.primary)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            
            HStack {
                Spacer()
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .frame(width: 250, height: 60)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}
