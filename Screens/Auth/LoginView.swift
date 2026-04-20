import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var phoneNumber = ""
    @State private var email = ""

    private var canContinue: Bool {
        HosteloFormatters.limitedPhone(phoneNumber).count == 10 || isValidEmail
    }

    private var isValidEmail: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@") && trimmed.contains(".")
    }

    var body: some View {
        HosteloScreen {
            HosteloTopBar(showBackButton: true)

            SectionHeader(
                title: "Login to your account",
                subtitle: "Enter your credentials to continue"
            )

            PhoneNumberField(phoneNumber: $phoneNumber)

            AuthDivider(text: "or")

            HosteloTextField(
                placeholder: "enter email id",
                text: $email,
                keyboardType: .emailAddress,
                textInputAutocapitalization: .never,
                autocorrectionDisabled: true,
                icon: nil
            )

            PrimaryButton(title: "Verify OTP", disabled: !canContinue) {
                if HosteloFormatters.limitedPhone(phoneNumber).count == 10 {
                    onboarding.phone = HosteloFormatters.limitedPhone(phoneNumber)
                } else if isValidEmail {
                    onboarding.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                }
                onboarding.otpNextRoute = .approvalStatus
                coordinator.push(.otp)
            }

            AuthDivider(text: "or signup with")

            SocialButtonRow()

            HStack(spacing: 4) {
                Text("New here?")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)

                Button("Create account") {
                    coordinator.push(.createAccount)
                }
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloBlue)
            }
            .frame(maxWidth: .infinity)
        }
        .onChange(of: phoneNumber) { _, newValue in
            phoneNumber = HosteloFormatters.limitedPhone(newValue)
            if !phoneNumber.isEmpty { email = "" }
        }
        .onChange(of: email) { _, newValue in
            email = newValue.replacingOccurrences(of: " ", with: "")
            if !email.isEmpty { phoneNumber = "" }
        }
    }
}
