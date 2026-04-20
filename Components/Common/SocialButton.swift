import SwiftUI

struct SocialButton: View {
    var icon: String

    var body: some View {
        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .frame(width: 56, height: 56)
            .background(Color(red: 0.91, green: 0.91, blue: 0.91))
            .cornerRadius(15)
    }
}