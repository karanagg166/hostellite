import SwiftUI

struct Campus: Identifiable, Hashable {
    let code: String
    let name: String
    let subtitle: String
    let emailDomain: String

    var id: String { code }
}

enum HosteloSampleData {
    static let campuses: [Campus] = [
        Campus(
            code: "IIITDMJ",
            name: "IIITDM Jabalpur",
            subtitle: "Indian Institute of Information Technology, Design and Manufacturing",
            emailDomain: "iiitdmj.ac.in"
        ),
        Campus(
            code: "IIITH",
            name: "IIIT Hyderabad",
            subtitle: "International Institute of Information Technology Hyderabad",
            emailDomain: "iiit.ac.in"
        ),
        Campus(
            code: "IITD",
            name: "IIT Delhi",
            subtitle: "Indian Institute of Technology Delhi",
            emailDomain: "iitd.ac.in"
        ),
        Campus(
            code: "IITB",
            name: "IIT Bombay",
            subtitle: "Indian Institute of Technology Bombay",
            emailDomain: "iitb.ac.in"
        ),
        Campus(
            code: "NITT",
            name: "NIT Trichy",
            subtitle: "National Institute of Technology Tiruchirappalli",
            emailDomain: "nitt.edu"
        ),
    ]

    static let hostels = [
        "Hall - 4 : Vivekananda boys hostel",
        "Hall - 3 : Bose boys hostel",
        "Hall - 2 : Raman boys hostel",
        "Hall - 1 : Tagore boys hostel",
    ]

    static let blocks = [
        "F Block",
        "E Block",
        "D Block",
        "C Block",
        "B Block",
        "A Block",
    ]

    static let rooms = [
        "F - 03",
        "F - 01",
        "F - 02",
        "F - 04",
        "E - 11",
        "E - 14",
        "D - 07",
        "C - 22",
    ]
}

enum HosteloFormatters {
    static func digitsOnly(_ value: String) -> String {
        value.filter(\.isNumber)
    }

    static func limitedPhone(_ value: String) -> String {
        String(digitsOnly(value).prefix(10))
    }

    static func phonePreview(_ value: String) -> String {
        let digits = limitedPhone(value)

        guard !digits.isEmpty else {
            return "+91 XXXXXXXXXX"
        }

        if digits.count <= 5 {
            return "+91 \(digits)"
        }

        let firstChunk = digits.prefix(5)
        let secondChunk = digits.dropFirst(5)
        return "+91 \(firstChunk) \(secondChunk)"
    }
}

extension Color {
    static let hosteloBlue = Color(red: 0.25, green: 0.53, blue: 0.69)
    static let hosteloBlueDark = Color(red: 0.18, green: 0.39, blue: 0.53)
    static let hosteloText = Color(red: 0.15, green: 0.16, blue: 0.20)
    static let hosteloMuted = Color(red: 0.46, green: 0.53, blue: 0.59)
    static let hosteloBorder = Color(red: 0.84, green: 0.89, blue: 0.93)
    static let hosteloSurface = Color(red: 0.96, green: 0.98, blue: 1.00)
    static let hosteloSky = Color(red: 0.92, green: 0.97, blue: 1.00)
    static let hosteloSuccess = Color(red: 0.32, green: 0.66, blue: 0.32)
    static let hosteloWarning = Color(red: 0.88, green: 0.67, blue: 0.16)
    static let hosteloDanger = Color(red: 0.88, green: 0.33, blue: 0.24)
}

struct HosteloScreen<Content: View>: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat
    private let content: () -> Content

    init(
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat = 24,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        ZStack {
            HosteloRootBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: alignment, spacing: spacing) {
                    content()
                }
                .frame(maxWidth: 392)
                .padding(.horizontal, 24)
                .padding(.top, 18)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct HosteloRootBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color.hosteloSky.opacity(0.95), .white, .white],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(Color.hosteloBlue.opacity(0.08))
                .frame(width: 220, height: 220)
                .offset(x: 72, y: -92)
        }
        .overlay(alignment: .topLeading) {
            Circle()
                .fill(Color.hosteloBlue.opacity(0.05))
                .frame(width: 170, height: 170)
                .offset(x: -72, y: -56)
        }
        .overlay(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 80, style: .continuous)
                .fill(Color.hosteloSky.opacity(0.35))
                .frame(width: 200, height: 120)
                .rotationEffect(.degrees(18))
                .offset(x: -90, y: 44)
        }
    }
}

struct HosteloTopBar: View {
    var showBackButton = false
    var progress: Int? = nil
    var totalSteps = 3

    @EnvironmentObject private var coordinator: NavigationCoordinator

    var body: some View {
        HStack(spacing: 16) {
            if showBackButton {
                Button(action: { coordinator.pop() }) {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.hosteloText)
                        }
                        .overlay {
                            Circle()
                                .stroke(Color.hosteloBorder, lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
            } else {
                AppLogo(size: 34)
            }

            if let progress {
                FlowProgressView(current: progress, total: totalSteps)
            } else {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FlowProgressView: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<max(total, 1), id: \.self) { index in
                Capsule()
                    .fill(index < current ? Color.hosteloBlue : Color.hosteloBorder)
                    .frame(maxWidth: .infinity)
                    .frame(height: 4)
            }
        }
    }
}

struct AppLogo: View {
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                .fill(Color.hosteloBlue)
                .frame(width: size, height: size)

            HStack(spacing: size * 0.10) {
                RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                    .fill(.white)
                    .frame(width: size * 0.18, height: size * 0.54)

                RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                    .fill(.white)
                    .frame(width: size * 0.14, height: size * 0.16)

                RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                    .fill(.white)
                    .frame(width: size * 0.18, height: size * 0.54)
            }
        }
        .shadow(color: Color.hosteloBlue.opacity(0.18), radius: 12, x: 0, y: 8)
    }
}

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var alignment: HorizontalAlignment = .leading

    private var textAlignment: TextAlignment {
        alignment == .center ? .center : .leading
    }

    private var frameAlignment: Alignment {
        alignment == .center ? .center : .leading
    }

    var body: some View {
        VStack(alignment: alignment, spacing: 10) {
            Text(title)
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.hosteloText)
                .multilineTextAlignment(textAlignment)

            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)
                    .multilineTextAlignment(textAlignment)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: frameAlignment)
    }
}

struct PrimaryButton: View {
    let title: String
    var iconSystemName: String? = nil
    var disabled = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)

                if let iconSystemName {
                    Image(systemName: iconSystemName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(disabled ? Color.hosteloBlue.opacity(0.55) : Color.hosteloBlue)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.hosteloBlue.opacity(disabled ? 0.10 : 0.22), radius: 14, x: 0, y: 10)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

struct SecondaryButton: View {
    let title: String
    var disabled = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(disabled ? Color.hosteloMuted.opacity(0.6) : Color.hosteloText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.hosteloBorder, lineWidth: 1.3)
                }
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

struct AuthDivider: View {
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Rectangle()
                .fill(Color.hosteloBorder)
                .frame(height: 1)

            Text(text)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)

            Rectangle()
                .fill(Color.hosteloBorder)
                .frame(height: 1)
        }
    }
}

enum SocialBrand: CaseIterable {
    case google
    case facebook
    case apple

    var foregroundColor: Color {
        switch self {
        case .google:
            return Color(red: 0.87, green: 0.30, blue: 0.19)
        case .facebook:
            return Color(red: 0.23, green: 0.35, blue: 0.68)
        case .apple:
            return Color.hosteloText
        }
    }
}

struct SocialButtonRow: View {
    var body: some View {
        HStack(spacing: 16) {
            ForEach(SocialBrand.allCases, id: \.self) { brand in
                SocialCircleButton(brand: brand)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct SocialCircleButton: View {
    let brand: SocialBrand

    var body: some View {
        Button(action: {}) {
            Circle()
                .fill(.white)
                .frame(width: 54, height: 54)
                .overlay {
                    Circle()
                        .stroke(Color.hosteloBorder, lineWidth: 1.3)
                }
                .overlay {
                    switch brand {
                    case .google:
                        Text("G")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(brand.foregroundColor)
                    case .facebook:
                        Text("f")
                            .font(.system(size: 25, weight: .heavy, design: .rounded))
                            .foregroundStyle(brand.foregroundColor)
                            .offset(y: 1)
                    case .apple:
                        Image(systemName: "apple.logo")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(brand.foregroundColor)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

struct HosteloFieldChrome<Content: View>: View {
    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        HStack(spacing: 12) {
            content()
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 56)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.hosteloBorder, lineWidth: 1.3)
        }
        .shadow(color: Color.black.opacity(0.03), radius: 12, x: 0, y: 8)
    }
}

struct HosteloTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textInputAutocapitalization: TextInputAutocapitalization = .never
    var autocorrectionDisabled = true
    var icon: String? = nil

    var body: some View {
        HosteloFieldChrome {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.hosteloMuted)
            }

            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloText)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(textInputAutocapitalization)
                .autocorrectionDisabled(autocorrectionDisabled)
        }
    }
}

struct PhoneNumberField: View {
    @Binding var phoneNumber: String

    var body: some View {
        HStack(spacing: 12) {
            HosteloFieldChrome {
                Image("twemoji_flag_india")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.hosteloMuted)
            }
            .frame(width: 80)

            HosteloFieldChrome {
                Text("+91")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)

                TextField("99567438562", text: $phoneNumber)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloText)
                    .keyboardType(.numberPad)
            }
        }
    }
}

struct ReadOnlyField: View {
    let value: String
    var icon: String? = nil
    var badgeText: String? = nil

    var body: some View {
        HosteloFieldChrome {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.hosteloSuccess)
            }

            Text(value)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloText)
                .lineLimit(1)

            Spacer(minLength: 0)

            if let badgeText {
                HosteloPill(text: badgeText, tint: .hosteloSuccess)
            }
        }
    }
}

struct HosteloPill: View {
    let text: String
    let tint: Color

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(tint.opacity(0.12))
            )
    }
}

struct StatusNoteRow: View {
    let systemImage: String
    let text: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(tint)
                .padding(.top, 2)

            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(tint.opacity(0.08))
        )
    }
}

struct SelectionMenuField: View {
    let title: String
    let placeholder: String
    let options: [String]
    @Binding var selection: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)
                .tracking(1.0)

            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection = option
                    }
                }
            } label: {
                HosteloFieldChrome {
                    Text(selection ?? placeholder)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(selection == nil ? Color.hosteloMuted : Color.hosteloText)

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.hosteloMuted)
                }
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CampusRow: View {
    let campus: Campus
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.hosteloBlue.opacity(0.10))
                        .frame(width: 50, height: 50)

                    Image(systemName: "building.2.crop.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.hosteloBlue)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(campus.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.hosteloText)
                        .multilineTextAlignment(.leading)

                    Text(campus.subtitle)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.hosteloMuted)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    HosteloPill(text: campus.code, tint: .hosteloBlue)
                }

                Spacer(minLength: 0)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.hosteloBlue : Color.hosteloBorder)
                    .padding(.top, 4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.hosteloSurface : .white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? Color.hosteloBlue : Color.hosteloBorder, lineWidth: 1.3)
            }
            .shadow(color: Color.black.opacity(isSelected ? 0.05 : 0.02), radius: 10, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }
}

struct IllustrationCard<Content: View>: View {
    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white, Color.hosteloSky.opacity(0.95)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(Color.hosteloBlue.opacity(0.10))
                .frame(width: 210, height: 210)
                .offset(x: -88, y: -86)

            Circle()
                .fill(Color.hosteloBlue.opacity(0.08))
                .frame(width: 180, height: 180)
                .offset(x: 116, y: -72)

            content()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 278)
        .shadow(color: Color.hosteloBlue.opacity(0.08), radius: 18, x: 0, y: 14)
    }
}

struct MiniDormBuilding: View {
    let width: CGFloat
    let height: CGFloat
    var accent: Color = .hosteloBlue

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(accent.opacity(0.55))
                .frame(width: width * 0.72, height: height * 0.14)
                .overlay {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(.white.opacity(0.55), lineWidth: 1)
                }
                .offset(y: 6)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.white)
                    .frame(width: width, height: height)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.hosteloBorder, lineWidth: 1.2)
                    }
                    .shadow(color: accent.opacity(0.15), radius: 12, x: 0, y: 10)

                VStack(spacing: height * 0.08) {
                    ForEach(0..<3, id: \.self) { _ in
                        HStack(spacing: width * 0.07) {
                            ForEach(0..<4, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(accent.opacity(0.22))
                                    .frame(width: width * 0.12, height: height * 0.11)
                            }
                        }
                    }
                }
                .padding(.top, height * 0.16)

                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(accent.opacity(0.32))
                    .frame(width: width * 0.16, height: height * 0.26)
                    .padding(.bottom, height * 0.06)
            }
        }
    }
}

struct StudentFigure: View {
    var accent: Color = .hosteloBlue
    var size: CGFloat = 38

    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(accent.opacity(0.75))
                .frame(width: size * 0.30, height: size * 0.30)

            RoundedRectangle(cornerRadius: size * 0.13, style: .continuous)
                .fill(accent.opacity(0.60))
                .frame(width: size * 0.42, height: size * 0.54)

            RoundedRectangle(cornerRadius: size * 0.08, style: .continuous)
                .fill(accent.opacity(0.50))
                .frame(width: size * 0.54, height: size * 0.12)
                .offset(y: -size * 0.12)
        }
    }
}

struct WelcomeIllustration: View {
    var body: some View {
        IllustrationCard {
            Rectangle()
                .fill(Color.hosteloBlue.opacity(0.16))
                .frame(width: 250, height: 10)
                .clipShape(Capsule(style: .continuous))
                .offset(y: 96)

            MiniDormBuilding(width: 156, height: 118)
                .offset(x: 18, y: -12)

            MiniDormBuilding(width: 94, height: 84, accent: .hosteloBlueDark)
                .offset(x: -108, y: 24)

            MiniDormBuilding(width: 108, height: 92)
                .offset(x: 118, y: 36)

            HStack(spacing: 14) {
                StudentFigure(size: 30)
                StudentFigure(accent: .hosteloBlueDark, size: 32)
                StudentFigure(size: 30)
                StudentFigure(accent: .hosteloBlueDark, size: 28)
            }
            .offset(y: 92)
        }
    }
}

struct CampusIllustration: View {
    var body: some View {
        IllustrationCard {
            MiniDormBuilding(width: 96, height: 74, accent: .hosteloBlueDark)
                .scaleEffect(0.90)
                .offset(x: -114, y: -4)

            MiniDormBuilding(width: 112, height: 84)
                .scaleEffect(0.92)
                .offset(x: -18, y: -40)

            MiniDormBuilding(width: 88, height: 68)
                .scaleEffect(0.88)
                .offset(x: 88, y: -2)

            MiniDormBuilding(width: 104, height: 76)
                .scaleEffect(0.85)
                .offset(x: -54, y: 60)

            MiniDormBuilding(width: 96, height: 72, accent: .hosteloBlueDark)
                .scaleEffect(0.82)
                .offset(x: 54, y: 70)

            Rectangle()
                .fill(Color.hosteloBlue.opacity(0.16))
                .frame(width: 240, height: 10)
                .clipShape(Capsule(style: .continuous))
                .offset(y: 106)
        }
    }
}
