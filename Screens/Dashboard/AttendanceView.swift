import SwiftUI

// MARK: - Models

enum AttendanceStatus {
    case approved, lateEntry, onLeave

    var label: String {
        switch self {
        case .approved:  return "approved"
        case .lateEntry: return "late entry"
        case .onLeave:   return "on leave"
        }
    }

    var color: Color {
        switch self {
        case .approved:  return Color.hosteloSuccess
        case .lateEntry: return Color.hosteloDanger
        case .onLeave:   return Color.hosteloWarning
        }
    }
}

struct AttendanceRecord: Identifiable {
    let id = UUID()
    let date: String
    let time: String?
    let status: AttendanceStatus
}

struct PenaltyRecord: Identifiable {
    let id = UUID()
    let amount: Int
    let date: String
    let time: String
    let status: AttendanceStatus
}

// MARK: - Semi-circle gauge shape

struct SemiArcShape: Shape {
    var start: Double = 0
    var end: Double = 1

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: rect.width / 2,
            startAngle: .degrees(180 + start * 180),
            endAngle:   .degrees(180 + end   * 180),
            clockwise: false
        )
        return p
    }
}

struct AttendanceGauge: View {
    let recorded: Double
    let late: Double
    let leave: Double
    let totalDays: Int

    private var recordedEnd: Double { recorded }
    private var lateEnd:     Double { recorded + late }
    private var leaveEnd:    Double { recorded + late + leave }

    var body: some View {
        ZStack {
            SemiArcShape(start: 0, end: 1)
                .stroke(Color.hosteloBorder.opacity(0.45), style: StrokeStyle(lineWidth: 14, lineCap: .butt))

            SemiArcShape(start: 0, end: recordedEnd)
                .stroke(Color.hosteloBlue,    style: StrokeStyle(lineWidth: 14, lineCap: .butt))

            SemiArcShape(start: recordedEnd, end: lateEnd)
                .stroke(Color.hosteloDanger,  style: StrokeStyle(lineWidth: 14, lineCap: .butt))

            SemiArcShape(start: lateEnd, end: leaveEnd)
                .stroke(Color.hosteloWarning, style: StrokeStyle(lineWidth: 14, lineCap: .butt))

            VStack(spacing: 2) {
                Text("\(totalDays) days")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hosteloText)
                Text("attendance history")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloMuted)
            }
            .offset(y: 12)
        }
        .frame(width: 148, height: 82)
    }
}

// MARK: - Status Badge

struct StatusBadge: View {
    let status: AttendanceStatus

    var body: some View {
        Text(status.label)
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundStyle(status.color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .overlay {
                Capsule(style: .continuous)
                    .stroke(status.color, lineWidth: 1)
            }
    }
}

// MARK: - Main View

struct AttendanceView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator

    @State private var showScanner = false
    @State private var showSuccess = false
    @State private var recordedTime = ""

    private let attendanceRecords: [AttendanceRecord] = [
        AttendanceRecord(date: "18 Apr, 2026", time: "22:24 pm", status: .approved),
        AttendanceRecord(date: "17 Apr, 2026", time: "21:12 pm", status: .approved),
        AttendanceRecord(date: "16 Apr, 2026", time: "22:43 pm", status: .lateEntry),
        AttendanceRecord(date: "15 Apr, 2026", time: "19:48 pm", status: .approved),
        AttendanceRecord(date: "14 Apr, 2026", time: nil,        status: .onLeave),
        AttendanceRecord(date: "13 Apr, 2026", time: nil,        status: .onLeave),
        AttendanceRecord(date: "12 Apr, 2026", time: nil,        status: .onLeave),
    ]

    private let penalties: [PenaltyRecord] = [
        PenaltyRecord(amount: 25, date: "16 Apr, 2026", time: "22:43 pm", status: .lateEntry),
        PenaltyRecord(amount: 15, date: "03 Apr, 2026", time: "22:36 pm", status: .lateEntry),
        PenaltyRecord(amount: 40, date: "04 Mar, 2026", time: "23:15 am", status: .lateEntry),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                navBar
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        gaugeCard
                        historySection
                        penaltiesSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }

            markAttendanceButton
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
        }
        .background(Color(red: 0.96, green: 0.97, blue: 0.99).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showScanner) {
            AttendanceScannerView(
                onScanned: { time in
                    recordedTime = time
                    showScanner = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        showSuccess = true
                    }
                },
                onDismiss: { showScanner = false }
            )
        }
        .sheet(isPresented: $showSuccess) {
            AttendanceSuccessSheet(time: recordedTime) {
                showSuccess = false
            }
            .presentationDetents([.height(260)])
            .presentationCornerRadius(24)
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        HStack {
            Button(action: { coordinator.pop() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.hosteloText)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Attendance")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)

            Spacer()

            Image(systemName: "arrow.left").foregroundStyle(.clear)
        }
    }

    // MARK: - Gauge Card

    private var gaugeCard: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.hosteloSky.opacity(0.6))
            .overlay {
                HStack(alignment: .bottom, spacing: 24) {
                    AttendanceGauge(
                        recorded: 0.52,
                        late: 0.16,
                        leave: 0.19,
                        totalDays: 31
                    )

                    VStack(alignment: .leading, spacing: 0) {
                        dateRangePill
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.bottom, 12)

                        legendItem(color: Color.hosteloBlue,   label: "attendance recorded")
                        legendItem(color: Color.hosteloDanger,  label: "late entry")
                        legendItem(color: Color.hosteloWarning, label: "leave")
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 130)
    }

    private var dateRangePill: some View {
        HStack(spacing: 4) {
            Text("21/01/26 – 22/01/26")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloText)
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color.hosteloMuted)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.hosteloBorder, lineWidth: 1)
                }
        )
    }

    @ViewBuilder
    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloMuted)
        }
        .padding(.vertical, 3)
    }

    // MARK: - Attendance History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Attendance history")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hosteloText)
                Spacer()
                Button("View all") {}
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloBlue)
                    .buttonStyle(.plain)
            }

            VStack(spacing: 0) {
                ForEach(attendanceRecords.indices, id: \.self) { i in
                    if i > 0 { Divider().padding(.horizontal, 16) }
                    attendanceRow(attendanceRecords[i])
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
    private func attendanceRow(_ record: AttendanceRecord) -> some View {
        HStack {
            Group {
                if let time = record.time {
                    Text("\(record.date)  •  \(time)")
                } else {
                    Text(record.date)
                }
            }
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .foregroundStyle(Color.hosteloText)

            Spacer()

            StatusBadge(status: record.status)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    // MARK: - Fines Section

    private var penaltiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Fine and penalties")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.hosteloText)
                Spacer()
                Button("View all") {}
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.hosteloBlue)
                    .buttonStyle(.plain)
            }

            VStack(spacing: 0) {
                ForEach(penalties.indices, id: \.self) { i in
                    if i > 0 { Divider().padding(.horizontal, 16) }
                    penaltyRow(penalties[i])
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
    private func penaltyRow(_ record: PenaltyRecord) -> some View {
        HStack(spacing: 12) {
            Text("₹\(record.amount)")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)
                .frame(width: 40, alignment: .leading)

            Text("\(record.date)  •  \(record.time)")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Color.hosteloText)

            Spacer()

            StatusBadge(status: record.status)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    // MARK: - Mark Attendance Button

    private var markAttendanceButton: some View {
        Button(action: {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            recordedTime = formatter.string(from: Date()) + "pm"
            showScanner = true
        }) {
            Text("Mark today's attendance")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.hosteloBlueDark)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color.hosteloBlueDark.opacity(0.30), radius: 12, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Success Sheet

struct AttendanceSuccessSheet: View {
    let time: String
    let onClose: () -> Void

    private let markedDate: String = {
        let f = DateFormatter()
        f.dateFormat = "d MMM, yyyy"
        return f.string(from: Date())
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Attendance recorded!")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hosteloText)

                    Text("marked on")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.hosteloMuted)
                    Text(markedDate)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.hosteloText)
                }

                Spacer()

                StatusBadge(status: .approved)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)

            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.hosteloSky)
                .frame(height: 62)
                .overlay {
                    Text(time)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.hosteloText)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

            Button(action: onClose) {
                Text("Close")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.hosteloBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 20)
        }
        .background(.white)
    }
}
