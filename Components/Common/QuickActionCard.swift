import SwiftUI
import Combine

struct QuickActionCard: View {
    var title: String
    var icon: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 100)
        .background(Color.blue)
        .cornerRadius(16)
    }
}