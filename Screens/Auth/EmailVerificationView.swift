import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var email = ""

    private var isValidEmail: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@") && trimmed.contains(".")
    }

    var body: some View {
        HosteloScreen(spacing: 22) {
            HosteloTopBar(showBackButton: true, progress: 3, totalSteps: 6)

            SectionHeader(
                title: "Verify your email",
                subtitle: "Enter your college email address to continue"
            )

            HosteloTextField(
                placeholder: "you@college.edu",
                text: $email,
                keyboardType: .emailAddress,
                textInputAutocapitalization: .never,
                autocorrectionDisabled: true,
                icon: "envelope"
            )

            StatusNoteRow(
                systemImage: isValidEmail ? "checkmark.seal.fill" : "info.circle.fill",
                text: isValidEmail
                    ? "Email looks good. We'll verify it with your campus later."
                    : "Use your college email for faster campus verification.",
                tint: isValidEmail ? .hosteloSuccess : .hosteloBlue
            )

            PrimaryButton(title: "Proceed", disabled: !isValidEmail) {
                onboarding.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                onboarding.otpNextRoute = .personalDetails
                coordinator.push(.emailOtp)
            }
        }
        .onChange(of: email) { _, newValue in
            email = newValue.replacingOccurrences(of: " ", with: "")
        }
    }
}
