import SwiftUI

struct PhoneInputField: View {

    @State private var phone: String = ""

    var body: some View {
        HStack(spacing: 10) {

            // Flag
            Image("twemoji_flag_india")
                .resizable()
                .frame(width: 30, height: 22)

            // Country Code
            Text("+91")
                .font(.system(size: 16, weight: .medium))

            // Dropdown icon
            Image(systemName: "chevron.down")
                .font(.system(size: 12))

            Divider()
                .frame(height: 20)

            // Input
            TextField("Enter phone number", text: $phone)
                .keyboardType(.numberPad)
        }
        .padding()
        .frame(height: 56)
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1.5)
        )
        .padding(.horizontal)
    }
}