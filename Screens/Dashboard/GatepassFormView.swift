import SwiftUI

// MARK: - Shared private form components

private struct FormNavBarView: View {
    let title: String
    let dismiss: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)
            Spacer()
            Button(action: dismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.hosteloText)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.55))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(Color(red: 0.88, green: 0.95, blue: 0.99))
    }
}

private struct FormSubmitButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.hosteloBlueDark)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.hosteloBlueDark.opacity(0.28), radius: 12, x: 0, y: 8)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
        .padding(.top, 12)
        .background(.white)
    }
}

private struct RadioRow: View {
    let label: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloText)
                Spacer()
                Circle()
                    .fill(selected ? Color.hosteloBlue : .clear)
                    .frame(width: 20, height: 20)
                    .overlay { Circle().stroke(selected ? Color.hosteloBlue : Color.hosteloBorder, lineWidth: 1.5) }
                    .overlay {
                        if selected { Circle().fill(.white).frame(width: 8, height: 8) }
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

private struct FormFieldLabel: View {
    let label: String
    var sublabel: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.hosteloText)
            if let sublabel {
                Text(sublabel)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)
            }
        }
    }
}

private struct MultilineArea: View {
    @Binding var text: String
    let placeholder: String
    var minHeight: CGFloat = 110

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.hosteloBorder, lineWidth: 1.3)
                }
                .shadow(color: Color.black.opacity(0.03), radius: 12, x: 0, y: 8)

            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloText)
                .frame(minHeight: minHeight)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)

            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .allowsHitTesting(false)
            }
        }
        .frame(minHeight: minHeight)
    }
}

// MARK: - Gatepass Form

struct GatepassFormView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var onboarding: OnboardingData

    @State private var passCategory: PassCategory = .dayOuting
    @State private var date = ""
    @State private var fromTime = ""
    @State private var toTime = ""
    @State private var reason = ""
    @State private var agreed = false

    enum PassCategory { case dayOuting, extendedLeave }

    var body: some View {
        VStack(spacing: 0) {
            FormNavBarView(title: "Gatepass request form", dismiss: { coordinator.pop() })

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    field("Name") {
                        autofill(onboarding.name)
                    }

                    HStack(alignment: .top, spacing: 12) {
                        field("Hostel name") { autofill(hostelName) }
                        field("Room no.")    { autofill(roomName)   }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pass category")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hosteloText)
                        RadioRow(label: "Gatepass for day outing",
                                 selected: passCategory == .dayOuting) { passCategory = .dayOuting }
                        RadioRow(label: "Extended leave pass",
                                 selected: passCategory == .extendedLeave) { passCategory = .extendedLeave }
                    }

                    field("Date", sublabel: "enter date of outing") {
                        HosteloFieldChrome {
                            TextField("DD/MM/YYYY", text: $date)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hosteloText)
                                .keyboardType(.numbersAndPunctuation)
                            Image(systemName: "calendar").font(.system(size: 18)).foregroundStyle(Color.hosteloMuted)
                        }
                    }

                    HStack(alignment: .top, spacing: 0) {
                        field("From", sublabel: "enter departure time") {
                            HosteloFieldChrome {
                                TextField("00:00", text: $fromTime)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.hosteloText).keyboardType(.numbersAndPunctuation)
                                Image(systemName: "clock").font(.system(size: 18)).foregroundStyle(Color.hosteloMuted)
                            }
                        }
                        Text("to").font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.hosteloMuted).padding(.horizontal, 8).padding(.top, 42)
                        field("To", sublabel: "enter arrival time") {
                            HosteloFieldChrome {
                                TextField("00:00", text: $toTime)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.hosteloText).keyboardType(.numbersAndPunctuation)
                                Image(systemName: "clock").font(.system(size: 18)).foregroundStyle(Color.hosteloMuted)
                            }
                        }
                    }

                    field("Reason") {
                        MultilineArea(text: $reason, placeholder: "Describe reason for seeking leave")
                    }

                    termsCheckbox
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }

            FormSubmitButton(title: "Request gatepass") {}
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.99).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Terms Checkbox

    private var termsCheckbox: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: { agreed.toggle() }) {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(agreed ? Color.hosteloBlue : .white)
                    .frame(width: 22, height: 22)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(agreed ? Color.hosteloBlue : Color.hosteloBorder, lineWidth: 1.5)
                    }
                    .overlay {
                        if agreed {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
            }
            .buttonStyle(.plain)

            Text("I hereby agree to confide by the hostel rules and ensure my return within the specified curfew timings. Hostel administration will not be held responsible for any mishap or delay outside campus premises.")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func field<C: View>(_ label: String, sublabel: String? = nil, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: sublabel != nil ? 2 : 6) {
            Text(label).font(.system(size: 15, weight: .semibold, design: .rounded)).foregroundStyle(Color.hosteloText)
            if let s = sublabel {
                Text(s).font(.system(size: 11, weight: .medium, design: .rounded)).foregroundStyle(Color.hosteloMuted)
            }
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func autofill(_ value: String) -> some View {
        HosteloFieldChrome {
            Text(value.isEmpty ? "autofilled from profile" : value)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(value.isEmpty ? Color.hosteloMuted : Color.hosteloText)
                .lineLimit(1)
            Spacer(minLength: 0)
        }
    }

    private var hostelName: String {
        guard let h = onboarding.selectedHostel else { return "" }
        return h.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces) ?? h
    }

    private var roomName: String {
        onboarding.selectedRoom?.replacingOccurrences(of: " - ", with: "-")
                                 .replacingOccurrences(of: " ", with: "") ?? ""
    }
}

// MARK: - Lost & Found Form

struct LostFoundFormView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator

    @State private var title = ""
    @State private var description = ""
    @State private var date = ""
    @State private var time = ""
    @State private var category: ItemCategory = .found
    @State private var imageSlots: [UIImage?] = [nil, nil, nil, nil]

    enum ItemCategory { case lost, found }

    var body: some View {
        VStack(spacing: 0) {
            FormNavBarView(title: "Report lost or found", dismiss: { coordinator.pop() })

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    field("Title") {
                        HosteloFieldChrome {
                            TextField("enter title or name of the item", text: $title)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.hosteloText)
                        }
                    }

                    field("Description") {
                        MultilineArea(text: $description, placeholder: "enter a description of the item")
                    }

                    HStack(alignment: .top, spacing: 14) {
                        field("Date", sublabel: "enter date when item was found/lost") {
                            HosteloFieldChrome {
                                TextField("DD/MM/YYYY", text: $date)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.hosteloText).keyboardType(.numbersAndPunctuation)
                                Image(systemName: "calendar").font(.system(size: 18)).foregroundStyle(Color.hosteloMuted)
                            }
                        }
                        field("Time", sublabel: "enter time when item was found/lost") {
                            HosteloFieldChrome {
                                TextField("00:00", text: $time)
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.hosteloText).keyboardType(.numbersAndPunctuation)
                                Image(systemName: "clock").font(.system(size: 18)).foregroundStyle(Color.hosteloMuted)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Listing category")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hosteloText)
                        RadioRow(label: "Lost item",  selected: category == .lost)  { category = .lost }
                        RadioRow(label: "Found item", selected: category == .found) { category = .found }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add images")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.hosteloText)
                        HStack(spacing: 10) {
                            ForEach(0..<4, id: \.self) { imageSlot(index: $0) }
                        }
                    }

                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }

            FormSubmitButton(title: "Publish listing", icon: "checkmark.square") {}
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.99).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private func imageSlot(index: Int) -> some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(index == 0 ? Color.hosteloBorder.opacity(0.4) : Color.hosteloSurface)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if index > 0 {
                    Image(systemName: "plus").font(.system(size: 18, weight: .medium)).foregroundStyle(Color.hosteloMuted)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.hosteloBorder, lineWidth: 1)
            }
    }

    @ViewBuilder
    private func field<C: View>(_ label: String, sublabel: String? = nil, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: sublabel != nil ? 2 : 6) {
            Text(label).font(.system(size: 15, weight: .semibold, design: .rounded)).foregroundStyle(Color.hosteloText)
            if let s = sublabel {
                Text(s).font(.system(size: 11, weight: .medium, design: .rounded)).foregroundStyle(Color.hosteloMuted)
            }
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
