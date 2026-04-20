import SwiftUI

struct ResidentDashboardView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HeaderView(userName: onboarding.name.isEmpty ? "Resident" : onboarding.name)

            // Banner / Image
            Image(AppImages.homeBanner)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
                .cornerRadius(16)
                .padding(.horizontal)

            // Quick Actions
            VStack(alignment: .leading, spacing: 12) {
                Text("Quick Actions")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal)

                HStack(spacing: 16) {
                    QuickActionCard(title: "Pay Rent", icon: "creditcard")
                    QuickActionCard(title: "Raise Complaint", icon: "exclamationmark.bubble")
                    QuickActionCard(title: "View Hostel", icon: "building.2")
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}