import SwiftUI

struct OverlayView: View {
  let settings: SublifySettings

  var body: some View {
    ZStack {
      // Modern gradient background with brand colors
      LinearGradient(
        colors: [
          backgroundColor.opacity(0.95),
          Color.sublifyPrimary.opacity(0.1),
          Color.sublifySecondary.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack(spacing: SublifySpacing.lg) {
        if settings.useCustomImage && !settings.customImagePath.isEmpty {
          // Custom image display with modern styling
          if let image = loadCustomImage() {
            Image(nsImage: image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: 800, maxHeight: 600)
              .cornerRadius(SublifyRadius.xl)
              .sublifyShadow(.large)
          } else {
            // Fallback to text if image fails to load
            motivationText
          }
        } else {
          // Modern text display
          motivationText
        }

        // Modern dismiss instruction
        HStack(spacing: SublifySpacing.sm) {
          Image(systemName: "hand.tap.fill")
            .font(.sublifyCaption)
          Text("Click anywhere to dismiss")
            .font(.sublifyCaption)
        }
        .foregroundColor(textColor.opacity(0.8))
        .padding(.horizontal, SublifySpacing.md)
        .padding(.vertical, SublifySpacing.sm)
        .background(Color.black.opacity(0.2))
        .cornerRadius(SublifyRadius.full)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: settings.motivationText)
  }

  private var motivationText: some View {
    Text(settings.motivationText)
      .font(.system(size: CGFloat(settings.fontSize), weight: .bold))
      .foregroundColor(textColor)
      .multilineTextAlignment(.center)
      .padding(SublifySpacing.xl)
      .background(
        RoundedRectangle(cornerRadius: SublifyRadius.xl)
          .fill(
            LinearGradient(
              colors: [
                Color.black.opacity(0.4),
                Color.sublifyPrimary.opacity(0.2)
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .background(.regularMaterial, in: RoundedRectangle(cornerRadius: SublifyRadius.xl))
      )
      .sublifyShadow(.large)
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