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
        switch settings.backgroundColor {
        case "blue":
            return Color.blue
        case "green":
            return Color.green
        case "purple":
            return Color.purple
        case "orange":
            return Color.orange
        case "red":
            return Color.red
        case "black":
            return Color.black
        default:
            return Color.blue
        }
    }

    private var textColor: Color {
        switch settings.textColor {
        case "white":
            return Color.white
        case "black":
            return Color.black
        case "yellow":
            return Color.yellow
        case "cyan":
            return Color.cyan
        default:
            return Color.white
        }
    }

    private func loadCustomImage() -> NSImage? {
        guard !settings.customImagePath.isEmpty else { return nil }
        return NSImage(contentsOfFile: settings.customImagePath)
    }
}
