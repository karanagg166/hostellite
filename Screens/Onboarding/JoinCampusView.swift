import SwiftUI

struct JoinCampusView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var campusCode = ""
    @State private var isVerified = false
    @State private var showError = false

    private var expectedCode: String {
        onboarding.campus?.code ?? ""
    }

    var body: some View {
        HosteloScreen(spacing: 22) {
            HosteloTopBar(showBackButton: true, progress: 1)

            SectionHeader(
                title: "Join your campus",
                subtitle: "Enter your campus code to verify and join \(onboarding.campus?.name ?? "your campus")."
            )

            HosteloTextField(
                placeholder: "Enter campus code (e.g. IIITDMJ)",
                text: $campusCode,
                keyboardType: .default,
                textInputAutocapitalization: .characters,
                autocorrectionDisabled: true,
                icon: "building.columns"
            )

            if isVerified {
                StatusNoteRow(
                    systemImage: "checkmark.seal.fill",
                    text: "Campus code verified! You're joining \(onboarding.campus?.name ?? "your campus").",
                    tint: .hosteloSuccess
                )
            } else if showError {
                StatusNoteRow(
                    systemImage: "xmark.circle.fill",
                    text: "Campus code doesn't match. Expected: \(expectedCode)",
                    tint: .hosteloDanger
                )
            } else {
                StatusNoteRow(
                    systemImage: "info.circle.fill",
                    text: "Your campus code was shared by your college admin. Enter it to verify.",
                    tint: .hosteloBlue
                )
            }

            PrimaryButton(
                title: isVerified ? "Continue" : "Verify code",
                disabled: campusCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ) {
                if isVerified {
                    coordinator.push(.personalDetails)
                } else {
                    verifyCampusCode()
                }
            }
        }
    }

    private func verifyCampusCode() {
        let trimmed = campusCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if trimmed == expectedCode.uppercased() {
            isVerified = true
            showError = false
        } else {
            isVerified = false
            showError = true
        }
    }
}
