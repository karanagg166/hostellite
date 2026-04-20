import SwiftUI
import Combine

struct HeaderView: View {
    var userName: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text(userName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
            }

            Spacer()

            Image(systemName: "bell")
                .font(.system(size: 20))
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
        }
        .padding(.horizontal)
    }
}