import SwiftUI

struct PersonalDetailsView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var fullName = ""

    private var cleanedName: String {
        fullName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        HosteloScreen(spacing: 22) {
            HosteloTopBar(showBackButton: true, progress: 2)

            SectionHeader(
                title: "Personal details",
                subtitle: "Add your full name so we can prepare your hostel request."
            )

            if !onboarding.email.isEmpty {
                ReadOnlyField(value: onboarding.email, icon: "checkmark.seal.fill", badgeText: "Verified")
            }

            HosteloTextField(
                placeholder: "Enter your name",
                text: $fullName,
                keyboardType: .default,
                textInputAutocapitalization: .words,
                autocorrectionDisabled: false,
                icon: "person"
            )

            if let campus = onboarding.campus {
                StatusNoteRow(
                    systemImage: "building.columns.fill",
                    text: "Campus selected: \(campus.name)",
                    tint: .hosteloBlue
                )
            }

            PrimaryButton(title: "Proceed", disabled: cleanedName.isEmpty) {
                onboarding.name = cleanedName
                coordinator.push(.hostelSelection)
            }
        }
        .onAppear {
            if fullName.isEmpty && !onboarding.name.isEmpty {
                fullName = onboarding.name
            }
        }
    }
}
