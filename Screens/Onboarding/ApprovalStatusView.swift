import SwiftUI

enum ApprovalState: Equatable {
    case approved
    case pending
    case denied

    var systemIcon: String {
        switch self {
        case .approved: return "checkmark.circle.fill"
        case .pending: return "clock.badge.checkmark.fill"
        case .denied: return "xmark.circle.fill"
        }
    }

    var title: String {
        switch self {
        case .approved: return "Woohoo!"
        case .pending: return "Hold on..."
        case .denied: return "Oops!"
        }
    }

    func subtitle(residentName: String, campusName: String) -> String {
        switch self {
        case .approved:
            return "Your hostel request for \(campusName) is approved. You can head straight into the dashboard."
        case .pending:
            return "Your request for \(residentName) was submitted for approval. Contact your warden if it takes too long."
        case .denied:
            return "The hostel warden rejected your request. Recheck your submitted details and try again."
        }
    }

    var accentColor: Color {
        switch self {
        case .approved: return .hosteloSuccess
        case .pending: return .hosteloWarning
        case .denied: return .hosteloDanger
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .approved: return "Go to dashboard"
        case .pending: return "Email request"
        case .denied: return "Request again"
        }
    }

    var primaryButtonIcon: String? {
        switch self {
        case .approved: return nil
        case .pending: return "arrow.up.right"
        case .denied: return nil
        }
    }

    var secondaryButtonTitle: String? {
        switch self {
        case .approved, .pending: return nil
        case .denied: return "Re-enter details"
        }
    }
}

struct ApprovalStatusView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData
    
    var status: ApprovalState

    var body: some View {
        HosteloScreen(alignment: .center, spacing: 24) {
            HosteloTopBar()

            ApprovalBadge(status: status)

            SectionHeader(
                title: status.title,
                subtitle: status.subtitle(
                    residentName: onboarding.name.isEmpty ? "Student" : onboarding.name,
                    campusName: onboarding.campus?.name ?? "Campus"
                ),
                alignment: .center
            )

            PrimaryButton(
                title: status.primaryButtonTitle,
                iconSystemName: status.primaryButtonIcon,
                action: handlePrimaryAction
            )

            if let secondaryButtonTitle = status.secondaryButtonTitle {
                SecondaryButton(title: secondaryButtonTitle, action: handleSecondaryAction)
            }
        }
    }

    private func handlePrimaryAction() {
        switch status {
        case .approved:
            coordinator.replaceAll(with: .dashboard)
        case .pending:
            coordinator.push(.requestHelp)
        case .denied:
            coordinator.push(.hostelSelection)
        }
    }

    private func handleSecondaryAction() {
        if status == .denied {
            coordinator.push(.personalDetails)
        }
    }
}

private struct ApprovalBadge: View {
    let status: ApprovalState

    var body: some View {
        ZStack {
            Circle()
                .fill(status.accentColor.opacity(0.12))
                .frame(width: 168, height: 168)

            Circle()
                .stroke(status.accentColor.opacity(0.18), lineWidth: 16)
                .frame(width: 124, height: 124)

            Image(systemName: status.systemIcon)
                .font(.system(size: 52, weight: .bold))
                .foregroundStyle(status.accentColor)
        }
    }
}

struct ApprovalStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ApprovalStatusView(status: .approved)
            .environmentObject(NavigationCoordinator())
            .environmentObject(OnboardingData())
    }
}
