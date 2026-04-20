import SwiftUI
import Combine

struct RequestHelpView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    var body: some View {
        HosteloScreen(spacing: 22) {
            HosteloTopBar(showBackButton: true)

            SectionHeader(
                title: "Email your request",
                subtitle: "Your onboarding is saved. If approval is taking too long, contact the hostel office from your verified campus email."
            )

            ReadOnlyField(
                value: onboarding.email.isEmpty ? "your-college-email@college.edu" : onboarding.email,
                icon: "checkmark.seal.fill",
                badgeText: "Verified"
            )

            HStack {
                QuickActionCard(title: onboarding.campus?.name ?? "Selected campus", icon: "building.columns.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            StatusNoteRow(
                systemImage: "envelope.open.fill",
                text: "Suggested subject: Hostel onboarding request follow-up for \(onboarding.name.isEmpty ? "Student" : onboarding.name).",
                tint: .hosteloBlue
            )

            StatusNoteRow(
                systemImage: "doc.text.fill",
                text: "Include your full name, hostel details, and the phone/email used during onboarding.",
                tint: .hosteloWarning
            )

            SecondaryButton(title: "Back to home") {
                coordinator.replaceAll(with: .welcome)
            }
        }
    }
}
