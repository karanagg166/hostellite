import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var phoneNumber = ""

    private var canContinue: Bool {
        HosteloFormatters.limitedPhone(phoneNumber).count == 10
    }

    var body: some View {
        HosteloScreen {
            HosteloTopBar(showBackButton: true)

            SectionHeader(
                title: "Create an account",
                subtitle: "Enter your credentials to continue"
            )

            PhoneNumberField(phoneNumber: $phoneNumber)

            PrimaryButton(title: "Sign up", disabled: !canContinue) {
                onboarding.phone = HosteloFormatters.limitedPhone(phoneNumber)
                onboarding.otpNextRoute = .emailVerification
                coordinator.push(.otp)
            }

            AuthDivider(text: "or signup with")

            SocialButtonRow()

            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)

                Button("Login") {
                    coordinator.push(.login)
                }
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloBlue)
            }
            .frame(maxWidth: .infinity)
        }
        .onChange(of: phoneNumber) { _, newValue in
            phoneNumber = HosteloFormatters.limitedPhone(newValue)
        }
    }
}