import SwiftUI

// MARK: - Settings Row Model

struct SettingsRow: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let type: RowLinkType

    enum RowLinkType {
        case internalNav, externalLink
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator

    private let preferences: [SettingsRow] = [
        SettingsRow(icon: "bell",                         label: "Notifications",        type: .internalNav),
        SettingsRow(icon: "gear.badge",                   label: "Device permissions",   type: .internalNav),
        SettingsRow(icon: "figure.stand",                 label: "Accessibility",        type: .internalNav),
        SettingsRow(icon: "globe",                        label: "Languages and region", type: .internalNav),
        SettingsRow(icon: "circle.lefthalf.filled",       label: "Themes",               type: .internalNav),
    ]

    private let legalPolicies: [SettingsRow] = [
        SettingsRow(icon: "doc.text",                     label: "Terms of Service",     type: .externalLink),
        SettingsRow(icon: "lock.shield",                  label: "Privacy Policy",       type: .externalLink),
    ]

    private let support: [SettingsRow] = [
        SettingsRow(icon: "questionmark.circle",          label: "Help Center",          type: .externalLink),
        SettingsRow(icon: "bubble.left.and.bubble.right", label: "FAQs",                 type: .internalNav),
    ]

    var body: some View {
        VStack(spacing: 0) {
            settingsNavBar
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    settingsSection(title: "Preferences",    items: preferences)
                    settingsSection(title: "Legal Policies", items: legalPolicies)
                    settingsSection(title: "Support",        items: support)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 28)
            }

            bottomTabBar
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.99).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Nav Bar

    private var settingsNavBar: some View {
        HStack {
            Button(action: { coordinator.pop() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.hosteloText)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Settings")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)

            Spacer()

            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.clear)
        }
    }

    // MARK: - Section Builder

    @ViewBuilder
    private func settingsSection(title: String, items: [SettingsRow]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)

            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { i in
                    if i > 0 {
                        Divider().padding(.leading, 58)
                    }
                    settingsRowView(items[i])
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.hosteloBorder, lineWidth: 1)
            }
        }
    }

    @ViewBuilder
    private func settingsRowView(_ row: SettingsRow) -> some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                Image(systemName: row.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.hosteloText)
                    .frame(width: 28)

                Text(row.label)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloText)

                Spacer()

                Image(systemName: row.type == .externalLink ? "arrow.up.right" : "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.hosteloText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bottom Tab Bar

    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            ForEach(HomeTab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    switch tab {
                    case .home:        coordinator.pop()
                    case .profile:     coordinator.push(.profile)
                    case .settings:    break
                    case .marketplace: break
                    }
                }) {
                    ZStack {
                        if tab == .settings {
                            Circle()
                                .fill(Color.hosteloBlue)
                                .frame(width: 56, height: 56)
                                .shadow(color: Color.hosteloBlue.opacity(0.25), radius: 10, x: 0, y: 6)
                        }

                        Image(systemName: tab.icon)
                            .font(.system(size: tab == .settings ? 22 : 20, weight: .medium))
                            .foregroundStyle(tab == .settings ? .white : Color.hosteloMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.07), radius: 20, x: 0, y: -6)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}
