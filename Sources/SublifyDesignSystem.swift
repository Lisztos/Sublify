import SwiftUI

// MARK: - Color Scheme
extension Color {
  static let sublifyPurple = Color(hex: "7A7BFF")
  static let sublifyViolet = Color(hex: "8D73FF")
  static let sublifyBlue = Color(hex: "7091FF")
  static let sublifyLightBlue = Color(hex: "5EA6FF")
  static let sublifyWhite = Color(hex: "FFFFFF")

  // Semantic colors
  static let sublifyPrimary = sublifyPurple
  static let sublifySecondary = sublifyViolet
  static let sublifyAccent = sublifyLightBlue
  static let sublifyBackground = Color(hex: "F1F5F9")
  static let sublifyCardBackground = Color.white
  static let sublifyCardBackgroundSecondary = Color(hex: "F8FAFC")
  static let sublifyText = Color(hex: "1F2937")
  static let sublifyTextSecondary = Color(hex: "64748B")
  static let sublifyBorder = Color(hex: "CBD5E1")

  // Status colors
  static let sublifySuccess = Color(hex: "10B981")
  static let sublifyError = Color(hex: "EF4444")
  static let sublifyWarning = Color(hex: "F59E0B")
}

// MARK: - Color Extension for Hex
extension Color {
  init(hex: String) {
      let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      var int: UInt64 = 0
      Scanner(string: hex).scanHexInt64(&int)
      let a, r, g, b: UInt64
      switch hex.count {
      case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
      case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
      case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
      default:
      (a, r, g, b) = (1, 1, 1, 0)
      }

      self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
      )
  }
}

// MARK: - Typography
extension Font {
  // Headings
  static let sublifyH1 = Font.system(size: 32, weight: .bold, design: .default)
  static let sublifyH2 = Font.system(size: 24, weight: .bold, design: .default)
  static let sublifyH3 = Font.system(size: 20, weight: .semibold, design: .default)
  static let sublifyH4 = Font.system(size: 18, weight: .semibold, design: .default)

  // Body text
  static let sublifyBodyLarge = Font.system(size: 16, weight: .regular, design: .default)
  static let sublifyBody = Font.system(size: 14, weight: .regular, design: .default)
  static let sublifyBodySmall = Font.system(size: 12, weight: .regular, design: .default)

  // UI elements
  static let sublifyButton = Font.system(size: 14, weight: .semibold, design: .default)
  static let sublifyCaption = Font.system(size: 11, weight: .medium, design: .default)
}

// MARK: - Spacing
struct SublifySpacing {
  static let xs: CGFloat = 4
  static let sm: CGFloat = 8
  static let md: CGFloat = 16
  static let lg: CGFloat = 24
  static let xl: CGFloat = 32
  static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct SublifyRadius {
  static let sm: CGFloat = 6
  static let md: CGFloat = 8
  static let lg: CGFloat = 12
  static let xl: CGFloat = 16
  static let full: CGFloat = 999
}

// MARK: - Shadow
extension View {
  func sublifyShadow(_ style: SublifyShadowStyle = .medium) -> some View {
      switch style {
      case .small:
      return self.shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
      case .medium:
      return self.shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
      case .large:
      return self.shadow(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 4)
      }
  }
}

enum SublifyShadowStyle {
  case small, medium, large
}

// MARK: - Button Styles
struct SublifyPrimaryButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
      configuration.label
      .font(.sublifyButton)
      .foregroundColor(.white)
      .padding(.horizontal, SublifySpacing.lg)
      .padding(.vertical, SublifySpacing.md)
      .background(
          LinearGradient(
    colors: isEnabled ? [.sublifyPrimary, .sublifySecondary] : [.sublifyTextSecondary],
    startPoint: .leading,
    endPoint: .trailing
          )
      )
      .cornerRadius(SublifyRadius.md)
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
      .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
      .sublifyShadow(.medium)
  }
}

struct SublifySecondaryButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
      configuration.label
      .font(.sublifyButton)
      .foregroundColor(isEnabled ? .sublifyPrimary : .sublifyTextSecondary)
      .padding(.horizontal, SublifySpacing.md)
      .padding(.vertical, SublifySpacing.sm)
      .background(Color.sublifyCardBackground)
      .overlay(
          RoundedRectangle(cornerRadius: SublifyRadius.md)
    .stroke(isEnabled ? Color.sublifyPrimary : Color.sublifyBorder, lineWidth: 1.5)
      )
      .cornerRadius(SublifyRadius.md)
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
      .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
  }
}

// MARK: - Card Style
struct SublifyCard<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
      self.content = content()
  }

  var body: some View {
      content
      .padding(SublifySpacing.lg)
      .background(Color.sublifyCardBackground)
      .cornerRadius(SublifyRadius.lg)
      .sublifyShadow(.medium)
  }
}

// MARK: - Status Badge
struct SublifyStatusBadge: View {
  let text: String
  let status: StatusType

  enum StatusType {
      case active, inactive, success, error, warning

      var color: Color {
      switch self {
      case .active, .success: return .sublifySuccess
      case .inactive: return .sublifyTextSecondary
      case .error: return .sublifyError
      case .warning: return .sublifyWarning
      }
      }

      var backgroundColor: Color {
      switch self {
      case .active, .success: return .sublifySuccess.opacity(0.1)
      case .inactive: return .sublifyTextSecondary.opacity(0.1)
      case .error: return .sublifyError.opacity(0.1)
      case .warning: return .sublifyWarning.opacity(0.1)
      }
      }
  }

  var body: some View {
      Text(text)
      .font(.sublifyCaption)
      .foregroundColor(status.color)
      .padding(.horizontal, SublifySpacing.sm)
      .padding(.vertical, SublifySpacing.xs)
      .background(status.backgroundColor)
      .cornerRadius(SublifyRadius.full)
  }
}

// MARK: - Input Field Style
struct SublifyTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .font(.sublifyBody)
      .foregroundColor(.sublifyText)
      .padding(.horizontal, SublifySpacing.md)
      .padding(.vertical, SublifySpacing.sm)
      .background(Color.sublifyCardBackground)
      .overlay(
        RoundedRectangle(cornerRadius: SublifyRadius.md)
          .stroke(Color.sublifyBorder, lineWidth: 1.5)
      )
      .cornerRadius(SublifyRadius.md)
      .shadow(color: Color.black.opacity(0.02), radius: 1, x: 0, y: 1)
  }
}

// MARK: - Toggle Style
struct SublifyToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
      HStack {
      configuration.label

      Spacer()

      Rectangle()
          .fill(configuration.isOn ? Color.sublifyPrimary : Color.sublifyBorder)
          .frame(width: 44, height: 24)
          .overlay(
    Circle()
      .fill(Color.white)
      .frame(width: 20, height: 20)
      .offset(x: configuration.isOn ? 10 : -10)
      .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
          )
          .cornerRadius(SublifyRadius.full)
          .onTapGesture {
    configuration.isOn.toggle()
          }
      }
  }
}

// MARK: - Clean Background
struct SublifyCleanBackground: View {
  var body: some View {
      Color.sublifyBackground
      .ignoresSafeArea()
  }
}

// MARK: - Modern Card with Border
struct SublifyModernCard<Content: View>: View {
  let content: Content
  let hasBorder: Bool
  let useSecondaryBackground: Bool

  init(hasBorder: Bool = true, useSecondaryBackground: Bool = false, @ViewBuilder content: () -> Content) {
    self.hasBorder = hasBorder
    self.useSecondaryBackground = useSecondaryBackground
    self.content = content()
  }

  var body: some View {
    content
      .padding(SublifySpacing.xl)
      .background(useSecondaryBackground ? Color.sublifyCardBackgroundSecondary : Color.sublifyCardBackground)
      .overlay(
        RoundedRectangle(cornerRadius: SublifyRadius.lg)
          .stroke(hasBorder ? Color.sublifyBorder.opacity(0.6) : Color.clear, lineWidth: 1)
      )
      .cornerRadius(SublifyRadius.lg)
      .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
      .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 1)
  }
}
