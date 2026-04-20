import SwiftUI

struct HostelSelectionView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var selectedHostel: String? = nil
    @State private var selectedBlock: String? = nil
    @State private var selectedRoom: String? = nil

    private var canSubmit: Bool {
        selectedHostel != nil && selectedBlock != nil && selectedRoom != nil
    }

    var body: some View {
        HosteloScreen(spacing: 20) {
            HosteloTopBar(showBackButton: true, progress: 6, totalSteps: 6)

            SectionHeader(
                title: "Hostel details",
                subtitle: "We need your hostel, block, and room before sending the request for approval."
            )

            SelectionMenuField(
                title: "Hostel",
                placeholder: "Select your hostel",
                options: HosteloSampleData.hostels,
                selection: $selectedHostel
            )

            SelectionMenuField(
                title: "Block",
                placeholder: "Select your block",
                options: HosteloSampleData.blocks,
                selection: $selectedBlock
            )

            SelectionMenuField(
                title: "Room",
                placeholder: "Select your room",
                options: HosteloSampleData.rooms,
                selection: $selectedRoom
            )

            StatusNoteRow(
                systemImage: "person.crop.circle.badge.checkmark",
                text: "Request will be created for \(onboarding.name) at \(onboarding.campus?.code ?? "campus").",
                tint: .hosteloBlue
            )

            PrimaryButton(title: "Request to join", disabled: !canSubmit) {
                onboarding.selectedHostel = selectedHostel
                onboarding.selectedBlock = selectedBlock
                onboarding.selectedRoom = selectedRoom
                onboarding.approvalStatus = .approved
                coordinator.push(.approvalStatus)
            }
        }
        .onChange(of: selectedHostel) { _, _ in
            selectedBlock = nil
            selectedRoom = nil
        }
        .onChange(of: selectedBlock) { _, _ in
            selectedRoom = nil
        }
    }
}
