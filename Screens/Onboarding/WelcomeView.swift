import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator

    var body: some View {
        HosteloScreen(spacing: 28) {
            HosteloTopBar()

            WelcomeIllustration()

            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome to")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.hosteloText)

                Text("Hostelo")
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.hosteloBlue)
            }

            Text("Hostel management made light.")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)

            VStack(spacing: 14) {
                PrimaryButton(title: "Sign up for free") {
                    coordinator.push(.createAccount)
                }

                SecondaryButton(title: "Login") {
                    coordinator.push(.login)
                }
            }

            Text("By signing up, you agree to our Terms of Use and Privacy Policy.")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
    }
}
