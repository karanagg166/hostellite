import SwiftUI

struct SearchCampusView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var searchText = ""
    @State private var selectedCampus: Campus? = nil

    private var filteredCampuses: [Campus] {
        guard !searchText.isEmpty else {
            return HosteloSampleData.campuses
        }

        return HosteloSampleData.campuses.filter { campus in
            campus.code.localizedCaseInsensitiveContains(searchText)
                || campus.name.localizedCaseInsensitiveContains(searchText)
                || campus.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        HosteloScreen(spacing: 20) {
            HosteloTopBar(showBackButton: true, progress: 1)

            SectionHeader(
                title: "Search your campus",
                subtitle: "Enter your campus code or search by college name to continue"
            )

            HosteloTextField(
                placeholder: "Search for your college",
                text: $searchText,
                keyboardType: .default,
                textInputAutocapitalization: .never,
                autocorrectionDisabled: false,
                icon: "magnifyingglass"
            )

            VStack(spacing: 12) {
                ForEach(filteredCampuses) { campus in
                    CampusRow(campus: campus, isSelected: selectedCampus == campus) {
                        selectedCampus = campus
                    }
                }
            }

            if let selectedCampus {
                StatusNoteRow(
                    systemImage: "checkmark.circle.fill",
                    text: "\(selectedCampus.name) selected. We'll use this campus for the next steps.",
                    tint: .hosteloSuccess
                )
            }

            PrimaryButton(title: "Proceed", disabled: selectedCampus == nil) {
                onboarding.campus = selectedCampus
                coordinator.push(.joinCampus)
            }
        }
    }
}
