import SwiftUI
import Combine

// MARK: - Shared Onboarding State

class OnboardingData: ObservableObject {
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var campus: Campus? = nil
    @Published var name: String = ""
    @Published var selectedHostel: String? = nil
    @Published var selectedBlock: String? = nil
    @Published var selectedRoom: String? = nil
    @Published var approvalStatus: ApprovalState = .pending
    @Published var otpNextRoute: AppRoute = .emailVerification
}

// MARK: - App Routes (simple cases, no associated values)

enum AppRoute: Hashable {
    case welcome
    case createAccount
    case login
    case otp
    case emailVerification
    case emailOtp
    case searchCampus
    case joinCampus
    case personalDetails
    case hostelSelection
    case approvalStatus
    case dashboard
    case requestHelp
}

// MARK: - Navigation Coordinator

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func replaceAll(with route: AppRoute) {
        var newPath = NavigationPath()
        newPath.append(route)
        path = newPath
    }
}
