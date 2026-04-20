import SwiftUI

@main
struct HosteloApp: App {
    @StateObject private var coordinator = NavigationCoordinator()
    @StateObject private var onboarding = OnboardingData()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                WelcomeView()
                    .navigationDestination(for: AppRoute.self) { route in
                        destinationView(for: route)
                    }
            }
            .environmentObject(coordinator)
            .environmentObject(onboarding)
        }
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .welcome:
            WelcomeView()
        case .createAccount:
            CreateAccountView()
        case .login:
            LoginView()
        case .otp:
            OTPVerificationView(
                recipient: HosteloFormatters.phonePreview(onboarding.phone),
                subtitle: "We've sent a 6-digit code to your mobile number.",
                nextRoute: onboarding.otpNextRoute
            )
        case .emailVerification:
            EmailVerificationView()
        case .emailOtp:
            OTPVerificationView(
                recipient: onboarding.email,
                subtitle: "We've sent a 6-digit code to your college email.",
                progressStep: 4,
                nextRoute: onboarding.otpNextRoute
            )
        case .searchCampus:
            SearchCampusView()
        case .joinCampus:
            JoinCampusView()
        case .personalDetails:
            PersonalDetailsView()
        case .hostelSelection:
            HostelSelectionView()
        case .approvalStatus:
            ApprovalStatusView(status: onboarding.approvalStatus)
        case .dashboard:
            ResidentDashboardView()
        case .requestHelp:
            RequestHelpView()
        case .profile:
            ProfileView()
        case .settings:
            SettingsView()
        case .attendance:
            AttendanceView()
        case .gatepassForm:
            GatepassFormView()
        case .lostFoundForm:
            LostFoundFormView()
        }
    }
}

