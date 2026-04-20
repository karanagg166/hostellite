import SwiftUI

// MARK: - Data Models

struct ServiceStatusLine {
    let text: String
    let type: StatusLineType

    enum StatusLineType {
        case neutral, warning, info
    }
}

struct ServiceItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let statusLines: [ServiceStatusLine]
    var route: AppRoute? = nil
}

// MARK: - Home Tab

enum HomeTab: Int, CaseIterable {
    case marketplace, home, settings, profile

    var icon: String {
        switch self {
        case .marketplace: return "storefront"
        case .home:        return "house.fill"
        case .settings:    return "gearshape"
        case .profile:     return "person"
        }
    }
}

// MARK: - Dashboard View

struct ResidentDashboardView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var searchText = ""
    @State private var announcementPage = 0
    @State private var selectedTab: HomeTab = .home

    private let services: [ServiceItem] = [
        ServiceItem(
            title: "Gate pass requests",
            icon: "list.bullet.clipboard",
            statusLines: [
                ServiceStatusLine(text: "1 request approved", type: .neutral),
                ServiceStatusLine(text: "2 requests pending", type: .warning)
            ],
            route: .gatepassForm
        ),
        ServiceItem(
            title: "Complaint tickets",
            icon: "person.crop.rectangle.badge.exclamationmark",
            statusLines: [
                ServiceStatusLine(text: "3 tickets unresolved", type: .warning)
            ]
        ),
        ServiceItem(
            title: "Attendance logs",
            icon: "calendar.badge.checkmark",
            statusLines: [
                ServiceStatusLine(text: "no alerts", type: .neutral)
            ],
            route: .attendance
        ),
        ServiceItem(
            title: "Housekeeping",
            icon: "sparkles",
            statusLines: [
                ServiceStatusLine(text: "cleaning scheduled\nfor 24/10/25", type: .info)
            ]
        ),
        ServiceItem(
            title: "Parcel collection",
            icon: "archivebox",
            statusLines: [
                ServiceStatusLine(text: "2 parcels to be collected", type: .warning)
            ]
        ),
        ServiceItem(
            title: "Lost and found",
            icon: "magnifyingglass.circle",
            statusLines: [
                ServiceStatusLine(text: "1 pending request", type: .warning)
            ],
            route: .lostFoundForm
        ),
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    homeHeader
                    searchBar
                    announcementsSection
                    servicesGrid
                }
                .padding(.top, 16)
                .padding(.bottom, 28)
            }

            bottomTabBar
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.99).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Header

    private var homeHeader: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.hosteloSky)
                .frame(width: 54, height: 54)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(Color.hosteloBlue)
                }
                .overlay { Circle().stroke(Color.hosteloBorder, lineWidth: 1) }

            VStack(alignment: .leading, spacing: 6) {
                Text("Hi, \(onboarding.name.isEmpty ? "Resident" : onboarding.name)!")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hosteloText)

                HStack(spacing: 6) {
                    RoomPill(text: hostelShortName)
                    RoomPill(text: roomShortName)
                }
            }

            Spacer(minLength: 0)

            Button(action: {}) {
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.hosteloSurface)
                        .frame(width: 44, height: 44)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.hosteloBorder, lineWidth: 1)
                        }
                        .overlay {
                            Image(systemName: "person.crop.rectangle")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(Color.hosteloText)
                        }

                    Text("ID card")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.hosteloMuted)
                }
            }
            .buttonStyle(.plain)

            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(.white)
                        .frame(width: 44, height: 44)
                        .overlay { Circle().stroke(Color.hosteloBorder, lineWidth: 1) }
                        .overlay {
                            Image(systemName: "bell")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color.hosteloText)
                        }

                    Circle()
                        .fill(Color.hosteloDanger)
                        .frame(width: 18, height: 18)
                        .overlay {
                            Text("2")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 4, y: -4)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.hosteloMuted)

                TextField("Search service, tickets, requests, etc", text: $searchText)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloText)
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.hosteloBorder, lineWidth: 1)
            }

            Button(action: {}) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.hosteloBlue)
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Announcements

    private var announcementsSection: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white)
                .frame(height: 76)
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.hosteloBorder, lineWidth: 1)
                }
                .overlay {
                    Text("Hostel announcements")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.hosteloText)
                }

            HStack(spacing: 6) {
                ForEach(0..<5, id: \.self) { i in
                    Circle()
                        .fill(i == announcementPage ? Color.hosteloBlue : Color.hosteloBorder)
                        .frame(width: i == announcementPage ? 8 : 6,
                               height: i == announcementPage ? 8 : 6)
                        .animation(.spring(response: 0.3), value: announcementPage)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Services Grid

    private var servicesGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)],
            spacing: 14
        ) {
            ForEach(services) { service in
                Button(action: {
                    if let route = service.route {
                        coordinator.push(route)
                    }
                }) {
                    ServiceCardView(service: service)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Bottom Tab Bar

    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            ForEach(HomeTab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    switch tab {
                    case .profile:  coordinator.push(.profile)
                    case .settings: coordinator.push(.settings)
                    default:        selectedTab = tab
                    }
                }) {
                    ZStack {
                        if tab == .home {
                            Circle()
                                .fill(Color.hosteloBlue)
                                .frame(width: 56, height: 56)
                                .shadow(color: Color.hosteloBlue.opacity(0.25), radius: 10, x: 0, y: 6)
                        }

                        Image(systemName: tab.icon)
                            .font(.system(size: tab == .home ? 22 : 20, weight: .medium))
                            .foregroundStyle(
                                tab == .home
                                    ? .white
                                    : (selectedTab == tab ? Color.hosteloBlue : Color.hosteloMuted)
                            )
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

    // MARK: - Helpers

    private var hostelShortName: String {
        guard let hostel = onboarding.selectedHostel else { return "Hall 4" }
        if hostel.contains("4") { return "Hall 4" }
        if hostel.contains("3") { return "Hall 3" }
        if hostel.contains("2") { return "Hall 2" }
        if hostel.contains("1") { return "Hall 1" }
        return hostel.components(separatedBy: ":").first?
            .trimmingCharacters(in: .whitespaces) ?? "Hall"
    }

    private var roomShortName: String {
        guard let room = onboarding.selectedRoom else { return "F-03" }
        return room.replacingOccurrences(of: " - ", with: "-")
                   .replacingOccurrences(of: " ", with: "")
    }
}

// MARK: - Room Pill

struct RoomPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(Color.hosteloText)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.hosteloSurface)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.hosteloBorder, lineWidth: 1)
                    }
            )
    }
}

// MARK: - Service Card

struct ServiceCardView: View {
    let service: ServiceItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.hosteloSky)
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: service.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.hosteloBlue)
                    }

                Spacer(minLength: 0)

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.hosteloMuted)
            }

            Spacer(minLength: 14)

            Text(service.title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.hosteloText)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 6)

            VStack(alignment: .leading, spacing: 2) {
                ForEach(service.statusLines.indices, id: \.self) { i in
                    Text(service.statusLines[i].text)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(statusColor(for: service.statusLines[i].type))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 148, alignment: .topLeading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.hosteloBorder, lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }

    private func statusColor(for type: ServiceStatusLine.StatusLineType) -> Color {
        switch type {
        case .neutral: return Color.hosteloMuted
        case .warning: return Color.hosteloWarning
        case .info:    return Color.hosteloBlue
        }
    }
}