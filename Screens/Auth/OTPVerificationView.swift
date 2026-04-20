import SwiftUI
import Combine

struct OTPVerificationView: View {
    let recipient: String
    let subtitle: String
    var buttonTitle = "Submit"
    var progressStep: Int? = nil
    var nextRoute: AppRoute

    @EnvironmentObject private var coordinator: NavigationCoordinator

    @State private var otpDigits: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @State private var timeRemaining = 30

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var isComplete: Bool {
        otpDigits.joined().count == otpDigits.count
    }

    var body: some View {
        HosteloScreen {
            HosteloTopBar(showBackButton: true, progress: progressStep, totalSteps: 6)

            VStack(alignment: .leading, spacing: 10) {
                Text("Enter the OTP sent to")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.hosteloText)

                Text(recipient)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hosteloBlue)
                    .fixedSize(horizontal: false, vertical: true)

                Text(subtitle)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    OTPDigitField(text: $otpDigits[index], isFocused: focusedField == index)
                        .focused($focusedField, equals: index)
                        .onChange(of: otpDigits[index]) { oldValue, newValue in
                            handleDigitChange(at: index, oldValue: oldValue, newValue: newValue)
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                Text("Didn't receive the code?")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)

                if timeRemaining > 0 {
                    Text("Resend in \(timeRemaining)s")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hosteloBlue)
                } else {
                    Button(action: { resetCode() }) {
                        Text("Resend")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.hosteloBlue)
                    }
                }
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 { timeRemaining -= 1 }
            }

            PrimaryButton(title: buttonTitle, disabled: !isComplete) {
                coordinator.push(nextRoute)
            }
        }
        .onAppear { focusedField = 0 }
    }

    private func handleDigitChange(at index: Int, oldValue: String, newValue: String) {
        let filteredValue = newValue.filter(\.isNumber)

        if filteredValue != newValue {
            otpDigits[index] = filteredValue
            return
        }

        if filteredValue.count > 1 {
            otpDigits[index] = String(filteredValue.suffix(1))
        }

        if otpDigits[index].count == 1, index < otpDigits.count - 1 {
            focusedField = index + 1
        } else if otpDigits[index].isEmpty, !oldValue.isEmpty, index > 0 {
            focusedField = index - 1
        }
    }

    private func resetCode() {
        otpDigits = Array(repeating: "", count: 6)
        timeRemaining = 30
        focusedField = 0
    }
}

// MARK: - OTP Digit Field (kept in same file)

struct OTPDigitField: View {
    @Binding var text: String
    var isFocused: Bool

    var body: some View {
        TextField("", text: $text)
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .foregroundStyle(Color.hosteloText)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .frame(width: 48, height: 56)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isFocused ? Color.hosteloBlue : Color.hosteloBorder, lineWidth: 1.5)
            }
            .shadow(color: Color.hosteloBlue.opacity(isFocused ? 0.12 : 0.03), radius: 10, x: 0, y: 6)
    }
}
