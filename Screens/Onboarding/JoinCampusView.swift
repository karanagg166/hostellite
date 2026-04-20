import SwiftUI

struct JoinCampusView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    var body: some View {
        HosteloScreen(spacing: 22) {
            HosteloTopBar(showBackButton: true, progress: 1, totalSteps: 6)

            Image(AppImages.joinCampusBanner)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            SectionHeader(
                title: "Join your campus",
                subtitle: "Find your college campus to connect with your hostel community and unlock all features."
            )

            Spacer(minLength: 40)

            PrimaryButton(title: "Find Campus") {
                coordinator.push(.searchCampus)
            }
        }
    }
}
