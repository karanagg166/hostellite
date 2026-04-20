import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    var body: some View {
        VStack(spacing: 0) {
            profileNavBar
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    profileCard
                    personalInfoSection
                    historySection
                    logoutButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.99).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Nav Bar

    private var profileNavBar: some View {
        HStack {
            Button(action: { coordinator.pop() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.hosteloText)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Profile")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)

            Spacer()

            Button(action: {}) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.hosteloText)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Profile Card

    private var profileCard: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer().frame(height: 44)

                VStack(spacing: 4) {
                    Text(onboarding.name.isEmpty ? "Resident" : onboarding.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hosteloText)

                    Text(studentId)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.hosteloMuted)
                }
                .padding(.bottom, 16)

                Rectangle()
                    .fill(Color.hosteloBorder.opacity(0.6))
                    .frame(height: 1)
                    .padding(.horizontal, 20)

                HStack(spacing: 0) {
                    profileStat(label: "Campus", value: onboarding.campus?.code ?? "IIITDMJ")

                    Rectangle()
                        .fill(Color.hosteloBorder.opacity(0.6))
                        .frame(width: 1, height: 40)

                    profileStat(label: "Hostel", value: hostelShortName)

                    Rectangle()
                        .fill(Color.hosteloBorder.opacity(0.6))
                        .frame(width: 1, height: 40)

                    profileStat(label: "Room no.", value: roomShortName)
                }
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background(Color.hosteloSky)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Circle()
                .fill(.white)
                .frame(width: 88, height: 88)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.hosteloBlue)
                }
                .overlay { Circle().stroke(Color.hosteloBorder, lineWidth: 1.5) }
        }
    }

    // MARK: - Personal Info Section

    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal information")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)

            VStack(spacing: 0) {
                infoRow(icon: "phone", label: "contact number", value: formattedPhone)

                Divider().padding(.leading, 56)

                infoRow(icon: "envelope", label: "email ID", value: displayEmail)

                Divider().padding(.leading, 56)

                HStack(spacing: 12) {
                    Image(systemName: "person.crop.rectangle")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.hosteloMuted)
                        .frame(width: 28)

                    Text("ID Card")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.hosteloMuted)

                    Spacer()

                    Button(action: {}) {
                        Text("View here")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.hosteloBlue)
                            .underline()
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.hosteloBorder, lineWidth: 1)
            }
        }
    }

    // MARK: - History Section

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("History")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)

            VStack(spacing: 0) {
                historyRow(icon: "clock.arrow.circlepath", label: "Your activity")

                Divider().padding(.leading, 56)

                historyRow(icon: "doc.text", label: "Monthly report")
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.hosteloBorder, lineWidth: 1)
            }
        }
    }

    // MARK: - Logout

    private var logoutButton: some View {
        Button(action: { coordinator.popToRoot() }) {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.hosteloDanger)

                Text("Logout")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.hosteloDanger)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.hosteloDanger, lineWidth: 1.5)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Sub-views

    @ViewBuilder
    private func profileStat(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)

            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.hosteloMuted)
                .frame(width: 28)

            Text(label)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    @ViewBuilder
    private func historyRow(icon: String, label: String) -> some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.hosteloMuted)
                    .frame(width: 28)

                Text(label)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloText)

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.hosteloText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private var studentId: String {
        guard !onboarding.email.isEmpty else { return "23BDS028" }
        return onboarding.email.components(separatedBy: "@").first?.uppercased() ?? "23BDS028"
    }

    private var displayEmail: String {
        onboarding.email.isEmpty ? "23bds028@iiitdmj.ac.in" : onboarding.email
    }

    private var formattedPhone: String {
        onboarding.phone.isEmpty ? "+91 98674 48353" : HosteloFormatters.phonePreview(onboarding.phone)
    }

    private var hostelShortName: String {
        guard let hostel = onboarding.selectedHostel else { return "Hall 4" }
        if hostel.contains("4") { return "Hall 4" }
        if hostel.contains("3") { return "Hall 3" }
        if hostel.contains("2") { return "Hall 2" }
        if hostel.contains("1") { return "Hall 1" }
        return hostel.components(separatedBy: ":").first?.trimmingCharacters(in: .whitespaces) ?? "Hall"
    }

    private var roomShortName: String {
        guard let room = onboarding.selectedRoom else { return "F-03" }
        return room.replacingOccurrences(of: " - ", with: "-")
                   .replacingOccurrences(of: " ", with: "")
    }
}
