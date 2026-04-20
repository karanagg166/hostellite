import SwiftUI

struct AttendanceScannerView: View {
    let onScanned: (String) -> Void
    let onDismiss: () -> Void

    @State private var scanLineOffset: CGFloat = -110
    @State private var animating = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                Spacer()

                scannerArea

                Spacer()

                Text("Scan the QR Code at your hostel\ngate to mark your attendance")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
            }
        }
        .onAppear { startAnimation() }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Spacer()

            Text("Mark attendance")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.hosteloText)

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.hosteloText)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(Color(red: 0.93, green: 0.96, blue: 0.99))
    }

    // MARK: - Scanner Area

    private var scannerArea: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .frame(width: 230, height: 230)

            qrCorners

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.hosteloBlue.opacity(0), Color.hosteloBlue.opacity(0.7), Color.hosteloBlue.opacity(0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 210, height: 2)
                .offset(y: scanLineOffset)
                .animation(
                    .linear(duration: 2.0).repeatForever(autoreverses: true),
                    value: animating
                )
        }
        .frame(width: 230, height: 230)
        .onTapGesture {
            let f = DateFormatter()
            f.dateFormat = "HH:mm"
            onScanned(f.string(from: Date()) + "pm")
        }
    }

    // MARK: - Corner Brackets

    private var qrCorners: some View {
        ZStack {
            cornerBracket(x: -115, y: -115, rotation: 0)
            cornerBracket(x: 115,  y: -115, rotation: 90)
            cornerBracket(x: 115,  y: 115,  rotation: 180)
            cornerBracket(x: -115, y: 115,  rotation: 270)
        }
    }

    @ViewBuilder
    private func cornerBracket(x: CGFloat, y: CGFloat, rotation: Double) -> some View {
        CornerBracketShape()
            .stroke(Color.hosteloBlue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 30, height: 30)
            .rotationEffect(.degrees(rotation))
            .offset(x: x, y: y)
    }

    private func startAnimation() {
        scanLineOffset = -110
        animating = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            scanLineOffset = 110
            animating = true
        }
    }
}

// MARK: - Corner Bracket Shape

struct CornerBracketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let len: CGFloat = min(rect.width, rect.height) * 0.9
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + len))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX + len, y: rect.minY))
        return p
    }
}
