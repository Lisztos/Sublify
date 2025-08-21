import SwiftUI

struct OverlayView: View {
    let settings: MotivatorSettings

    var body: some View {
        ZStack {
            // Background with opacity
            backgroundColor
                .opacity(0.9)
                .ignoresSafeArea()

            VStack {
                if settings.useCustomImage && !settings.customImagePath.isEmpty {
                    // Custom image display
                    if let image = loadCustomImage() {
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 800, maxHeight: 600)
                    } else {
                        // Fallback to text if image fails to load
                        motivationText
                    }
                } else {
                    // Text display
                    motivationText
                }

                Text("Click anywhere to dismiss")
                    .font(.caption)
                    .foregroundColor(textColor.opacity(0.7))
                    .padding(.top, 20)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: settings.motivationText)
    }

    private var motivationText: some View {
        Text(settings.motivationText)
            .font(.system(size: CGFloat(settings.fontSize), weight: .bold))
            .foregroundColor(textColor)
            .multilineTextAlignment(.center)
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.3))
            )
    }

    private var backgroundColor: Color {
        return settings.backgroundColor
    }

    private var textColor: Color {
        return settings.textColor
    }

    private func loadCustomImage() -> NSImage? {
        guard !settings.customImagePath.isEmpty else { return nil }
        return NSImage(contentsOfFile: settings.customImagePath)
    }
}
