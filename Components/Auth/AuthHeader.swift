import SwiftUI

struct AuthHeader: View {
    var title: String
    var subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.custom("Grave Presse", size: 36).weight(.heavy))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))

            Text(subtitle)
                .font(.custom("Manrope", size: 18).weight(.medium))
                .foregroundColor(Color(red: 0.64, green: 0.64, blue: 0.64))
        }
        .padding(.horizontal)
    }
}