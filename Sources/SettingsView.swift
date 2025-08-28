import SwiftUI

struct SettingsView: View {
  @ObservedObject var sublifyManager: SublifyManager
  @Environment(\.dismiss) private var dismiss
  @State private var showingImagePicker = false
  @State private var hoveredPreset: String? = nil

  var body: some View {
    VStack(spacing: 0) {
      SettingsHeader(sublifyManager: sublifyManager, dismiss: dismiss)

      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: SublifySpacing.lg) {
          TimingSection(sublifyManager: sublifyManager, hoveredPreset: $hoveredPreset)
            .padding(.top, SublifySpacing.sm)

          ContentSection(sublifyManager: sublifyManager, showingImagePicker: $showingImagePicker)

          AppearanceSection(sublifyManager: sublifyManager)
          
          BehaviorSection(sublifyManager: sublifyManager)

          PreviewSection(sublifyManager: sublifyManager, testDisplay: testDisplay)
        }
        .padding(.horizontal, SublifySpacing.xl)
        .padding(.vertical, SublifySpacing.lg)
      }
    }
    .background(Color.sublifyBackground)
    .frame(width: 560, height: 720)
    .cornerRadius(SublifyRadius.xl)
    .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 10)
    .fileImporter(
      isPresented: $showingImagePicker,
      allowedContentTypes: [.image],
      allowsMultipleSelection: false
    ) { result in
      switch result {
      case .success(let files):
        if let file = files.first {
          sublifyManager.settings.customImagePath = file.path
        }
      case .failure(let error):
        print("Error selecting image: \(error)")
      }
    }
  }

  private func testDisplay() {
    let screen = NSScreen.main ?? NSScreen.screens.first!
    let overlayView = OverlayView(settings: sublifyManager.settings)

    let testWindow = NSWindow(
      contentRect: screen.frame,
      styleMask: [.borderless],
      backing: .buffered,
      defer: false
    )

    testWindow.contentView = NSHostingView(rootView: overlayView)
    testWindow.backgroundColor = NSColor.clear
    testWindow.isOpaque = false
    testWindow.level = .screenSaver
    testWindow.makeKeyAndOrderFront(nil)

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      testWindow.orderOut(nil)
    }

    let clickGesture = NSClickGestureRecognizer { _ in
      testWindow.orderOut(nil)
    }
    testWindow.contentView?.addGestureRecognizer(clickGesture)
  }
}

// MARK: - Header Component
struct SettingsHeader: View {
  @ObservedObject var sublifyManager: SublifyManager
  let dismiss: DismissAction

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color.sublifyPrimary.opacity(0.05), Color.sublifySecondary.opacity(0.03)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )

      VStack(spacing: SublifySpacing.xs) {
        HStack {
          Button(action: { dismiss() }) {
            HStack(spacing: SublifySpacing.xs) {
              Image(systemName: "chevron.left")
                .font(.system(size: 12, weight: .semibold))
              Text("Back")
                .font(.sublifyButton)
            }
            .foregroundColor(.sublifyTextSecondary)
          }
          .buttonStyle(PlainButtonStyle())
          .padding(.horizontal, SublifySpacing.md)
          .padding(.vertical, SublifySpacing.sm)
          .background(Color.sublifyCardBackground.opacity(0.8))
          .cornerRadius(SublifyRadius.md)
          .onHover { isHovered in
            if isHovered {
              NSCursor.pointingHand.set()
            } else {
              NSCursor.arrow.set()
            }
          }

          Spacer()

          Button("Done") {
            dismiss()
          }
          .buttonStyle(SublifySecondaryButtonStyle())
        }

        Text("Settings")
          .font(.system(size: 28, weight: .bold, design: .default))
          .foregroundColor(.sublifyText)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, SublifySpacing.xs)

        Text("Customize your subliminal experience")
          .font(.sublifyBody)
          .foregroundColor(.sublifyTextSecondary)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, SublifySpacing.xl)
      .padding(.vertical, SublifySpacing.lg)
    }
    .frame(height: 140)
  }
}

// MARK: - Timing Section
struct TimingSection: View {
  @ObservedObject var sublifyManager: SublifyManager
  @Binding var hoveredPreset: String?

  var body: some View {
    VStack(alignment: .leading, spacing: SublifySpacing.md) {
      Label {
        Text("Timing")
          .font(.sublifyH4)
          .foregroundColor(.sublifyText)
      } icon: {
        Image(systemName: "clock.fill")
          .foregroundColor(.sublifyPrimary)
          .font(.system(size: 14))
      }

      VStack(spacing: 0) {
        TimingRow(
          title: "Display Frequency",
          subtitle: "How often to show messages",
          value: Binding(
            get: { sublifyManager.settings.intervalMinutes },
            set: { sublifyManager.settings.intervalMinutes = min(max($0, 1), 60) }
          ),
          unit: "min"
        )

        Divider()
          .background(Color.sublifyBorder.opacity(0.5))

        TimingRow(
          title: "Display Duration",
          subtitle: "How long each message appears",
          value: $sublifyManager.settings.displayDurationMs,
          unit: "ms"
        )
      }
      .cornerRadius(SublifyRadius.lg)
      .overlay(
        RoundedRectangle(cornerRadius: SublifyRadius.lg)
          .stroke(Color.sublifyBorder.opacity(0.3), lineWidth: 1)
      )

      TimingPresets(
        currentValue: sublifyManager.settings.displayDurationMs,
        onSelect: { sublifyManager.settings.displayDurationMs = $0 },
        hoveredPreset: $hoveredPreset
      )
    }
  }
}

// MARK: - Timing Row
struct TimingRow: View {
  let title: String
  let subtitle: String
  @Binding var value: Int
  let unit: String

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(.sublifyText)
        Text(subtitle)
          .font(.system(size: 11))
          .foregroundColor(.sublifyTextSecondary)
      }

      Spacer()

      HStack(spacing: SublifySpacing.xs) {
        TextField("", value: $value, format: .number)
          .multilineTextAlignment(.center)
          .frame(width: 100)
          .textFieldStyle(CompactTextFieldStyle())

        Text(unit)
          .font(.system(size: 12))
          .foregroundColor(.sublifyTextSecondary)
      }
    }
    .padding(SublifySpacing.md)
    .background(Color.sublifyCardBackground)
  }
}

// MARK: - Timing Presets
struct TimingPresets: View {
  let currentValue: Int
  let onSelect: (Int) -> Void
  @Binding var hoveredPreset: String?

  let presets = [
    ("Subliminal", 125),
    ("Brief", 500),
    ("Visible", 3000)
  ]

  var body: some View {
    HStack(spacing: SublifySpacing.sm) {
      ForEach(presets, id: \.0) { preset in
        PresetButton(
          label: preset.0,
          value: preset.1,
          isSelected: currentValue == preset.1,
          isHovered: hoveredPreset == preset.0,
          action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
              onSelect(preset.1)
            }
          },
          onHover: { isHovered in
            withAnimation(.easeInOut(duration: 0.15)) {
              hoveredPreset = isHovered ? preset.0 : nil
            }
          }
        )
      }
    }
  }
}

// MARK: - Preset Button
struct PresetButton: View {
  let label: String
  let value: Int
  let isSelected: Bool
  let isHovered: Bool
  let action: () -> Void
  let onHover: (Bool) -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 2) {
        Text(label)
          .font(.system(size: 11, weight: .semibold))
          .foregroundColor(isSelected ? .sublifyPrimary : .sublifyText)
        Text("\(value)ms")
          .font(.system(size: 10))
          .foregroundColor(isSelected ? .sublifyPrimary.opacity(0.8) : .sublifyTextSecondary)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, SublifySpacing.sm)
      .background(backgroundGradient)
      .overlay(borderOverlay)
      .cornerRadius(SublifyRadius.sm)
    }
    .buttonStyle(PlainButtonStyle())
    .scaleEffect(isHovered ? 1.02 : 1.0)
    .onHover { isHovered in
      onHover(isHovered)
      if isHovered {
        NSCursor.pointingHand.set()
      } else {
        NSCursor.arrow.set()
      }
    }
  }

  @ViewBuilder
  private var backgroundGradient: some View {
    if isSelected {
      LinearGradient(
        colors: [Color.sublifyPrimary.opacity(0.15), Color.sublifySecondary.opacity(0.15)],
        startPoint: .leading,
        endPoint: .trailing
      )
    } else {
      Color.white
    }
  }

  private var borderOverlay: some View {
    RoundedRectangle(cornerRadius: SublifyRadius.sm)
      .stroke(
        isSelected ? Color.sublifyPrimary : Color.sublifyBorder.opacity(0.3),
        lineWidth: isSelected ? 1.5 : 1
      )
  }
}

// MARK: - Content Section
struct ContentSection: View {
  @ObservedObject var sublifyManager: SublifyManager
  @Binding var showingImagePicker: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: SublifySpacing.md) {
      Label {
        Text("Content")
          .font(.sublifyH4)
          .foregroundColor(.sublifyText)
      } icon: {
        Image(systemName: "text.quote")
          .foregroundColor(.sublifyPrimary)
          .font(.system(size: 14))
      }

      VStack(spacing: 0) {
        ContentToggleRow(sublifyManager: sublifyManager)

        if sublifyManager.settings.useCustomImage {
          Divider()
            .background(Color.sublifyBorder.opacity(0.5))
          ImagePickerRow(
            imagePath: sublifyManager.settings.customImagePath,
            showPicker: { showingImagePicker = true }
          )
        } else {
          Divider()
            .background(Color.sublifyBorder.opacity(0.5))
          TextEditorRow(text: $sublifyManager.settings.motivationText)
        }
      }
      .cornerRadius(SublifyRadius.lg)
      .overlay(
        RoundedRectangle(cornerRadius: SublifyRadius.lg)
          .stroke(Color.sublifyBorder.opacity(0.3), lineWidth: 1)
      )
    }
  }
}

// MARK: - Content Toggle Row
struct ContentToggleRow: View {
  @ObservedObject var sublifyManager: SublifyManager

  var body: some View {
    HStack {
      Label {
        Text("Use Custom Image")
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(.sublifyText)
      } icon: {
        Image(systemName: sublifyManager.settings.useCustomImage ? "photo.fill" : "text.alignleft")
          .foregroundColor(.sublifyPrimary.opacity(0.8))
          .font(.system(size: 12))
      }

      Spacer()

      Toggle("", isOn: $sublifyManager.settings.useCustomImage)
        .toggleStyle(SublifyToggleStyle())
    }
    .padding(SublifySpacing.md)
    .background(Color.sublifyCardBackground)
  }
}

// MARK: - Image Picker Row
struct ImagePickerRow: View {
  let imagePath: String
  let showPicker: () -> Void

  var body: some View {
    VStack(spacing: SublifySpacing.sm) {
      HStack {
        Image(systemName: "folder.fill")
          .foregroundColor(.sublifyTextSecondary)
          .font(.system(size: 12))

        Text(fileName)
          .font(.system(size: 12))
          .foregroundColor(imagePath.isEmpty ? .sublifyTextSecondary : .sublifyText)
          .lineLimit(1)
          .truncationMode(.middle)

        Spacer()

        Button("Browse", action: showPicker)
          .font(.system(size: 11, weight: .semibold))
          .foregroundColor(.sublifyPrimary)
          .padding(.horizontal, SublifySpacing.md)
          .padding(.vertical, SublifySpacing.xs)
          .background(Color.sublifyPrimary.opacity(0.1))
          .cornerRadius(SublifyRadius.sm)
          .buttonStyle(PlainButtonStyle())
          .onHover { isHovered in
            if isHovered {
              NSCursor.pointingHand.set()
            } else {
              NSCursor.arrow.set()
            }
          }
      }
    }
    .padding(SublifySpacing.md)
    .background(Color.sublifyCardBackgroundSecondary)
  }

  private var fileName: String {
    imagePath.isEmpty ? "No image selected" : URL(fileURLWithPath: imagePath).lastPathComponent
  }
}

// MARK: - Text Editor Row
struct TextEditorRow: View {
  @Binding var text: String

  var body: some View {
    VStack(alignment: .leading, spacing: SublifySpacing.md) {
      HStack {
        Text("Motivational Message")
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(.sublifyTextSecondary)

        Spacer()

        Text("\(text.count) characters")
          .font(.system(size: 10))
          .foregroundColor(.sublifyTextSecondary.opacity(0.7))
      }

      TextEditor(text: $text)
        .font(.system(size: 13))
        .frame(height: 80)
        .padding(SublifySpacing.sm)
        .background(Color.sublifyCardBackgroundSecondary)
        .cornerRadius(SublifyRadius.sm)
        .overlay(
          RoundedRectangle(cornerRadius: SublifyRadius.sm)
            .stroke(Color.sublifyBorder.opacity(0.3), lineWidth: 1)
        )
    }
    .padding(SublifySpacing.md)
    .background(Color.sublifyCardBackground)
  }
}

// MARK: - Appearance Section
struct AppearanceSection: View {
  @ObservedObject var sublifyManager: SublifyManager

  var body: some View {
    VStack(alignment: .leading, spacing: SublifySpacing.md) {
      Label {
        Text("Appearance")
          .font(.sublifyH4)
          .foregroundColor(.sublifyText)
      } icon: {
        Image(systemName: "paintbrush.fill")
          .foregroundColor(.sublifyPrimary)
          .font(.system(size: 14))
      }

      VStack(spacing: SublifySpacing.md) {
        HStack(spacing: SublifySpacing.md) {
          ColorPickerItem(
            title: "Background",
            color: $sublifyManager.settings.backgroundColor
          )

          ColorPickerItem(
            title: "Text",
            color: $sublifyManager.settings.textColor
          )

          FontSizeItem(
            fontSize: $sublifyManager.settings.fontSize
          )
        }
      }
    }
  }
}

// MARK: - Color Picker Item
struct ColorPickerItem: View {
  let title: String
  @Binding var color: Color

  var body: some View {
    VStack(alignment: .leading, spacing: SublifySpacing.xs) {
      Text(title)
        .font(.system(size: 11, weight: .medium))
        .foregroundColor(.sublifyTextSecondary)

      HStack {
        ColorPicker("", selection: $color, supportsOpacity: false)
          .labelsHidden()
          .frame(width: 36, height: 36)

        Text("Color")
          .font(.system(size: 12))
          .foregroundColor(.sublifyText)
      }
      .padding(SublifySpacing.sm)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.sublifyCardBackground)
      .cornerRadius(SublifyRadius.md)
      .overlay(
        RoundedRectangle(cornerRadius: SublifyRadius.md)
          .stroke(Color.sublifyBorder.opacity(0.3), lineWidth: 1)
      )
    }
  }
}

// MARK: - Font Size Item
struct FontSizeItem: View {
  @Binding var fontSize: Int

  var body: some View {
    VStack(alignment: .leading, spacing: SublifySpacing.xs) {
      Text("Font Size")
        .font(.system(size: 11, weight: .medium))
        .foregroundColor(.sublifyTextSecondary)

      HStack {
        TextField("", value: $fontSize, format: .number)
          .multilineTextAlignment(.center)
          .frame(width: 70)
          .textFieldStyle(CompactTextFieldStyle())

        Text("pt")
          .font(.system(size: 12))
          .foregroundColor(.sublifyText)
      }
      .padding(SublifySpacing.sm)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.sublifyCardBackground)
      .cornerRadius(SublifyRadius.md)
      .overlay(
        RoundedRectangle(cornerRadius: SublifyRadius.md)
          .stroke(Color.sublifyBorder.opacity(0.3), lineWidth: 1)
      )
    }
  }
}

// MARK: - Behavior Section
struct BehaviorSection: View {
  @ObservedObject var sublifyManager: SublifyManager

  var body: some View {
    VStack(alignment: .leading, spacing: SublifySpacing.md) {
      Label {
        Text("App Behavior")
          .font(.sublifyH4)
          .foregroundColor(.sublifyText)
      } icon: {
        Image(systemName: "gear.circle.fill")
          .foregroundColor(.sublifyPrimary)
          .font(.system(size: 14))
      }

      VStack(spacing: 0) {
        BehaviorToggleRow(
          title: "Show in Menu Bar",
          subtitle: "Display app icon in the menu bar for quick access",
          icon: "menubar.rectangle",
          isOn: $sublifyManager.settings.showInMenuBar,
          onChange: { _ in
            updateDockAndMenuBar()
          }
        )

        Divider()
          .background(Color.sublifyBorder.opacity(0.5))

        BehaviorToggleRow(
          title: "Hide from Dock",
          subtitle: "Remove app icon from the Dock when running",
          icon: "dock.rectangle",
          isOn: $sublifyManager.settings.hideFromDock,
          onChange: { _ in
            updateDockAndMenuBar()
          }
        )
      }
      .cornerRadius(SublifyRadius.lg)
      .overlay(
        RoundedRectangle(cornerRadius: SublifyRadius.lg)
          .stroke(Color.sublifyBorder.opacity(0.3), lineWidth: 1)
      )
    }
  }
  
  private func updateDockAndMenuBar() {
    // Update dock and menu bar visibility
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if let appDelegate = NSApp.delegate as? AppDelegate {
        appDelegate.updateDockAndMenuBarVisibility()
      }
    }
  }
}

// MARK: - Behavior Toggle Row
struct BehaviorToggleRow: View {
  let title: String
  let subtitle: String
  let icon: String
  @Binding var isOn: Bool
  let onChange: (Bool) -> Void

  var body: some View {
    HStack {
      HStack(spacing: SublifySpacing.sm) {
        Image(systemName: icon)
          .foregroundColor(.sublifyPrimary.opacity(0.8))
          .font(.system(size: 12))
          .frame(width: 16)

        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.sublifyText)
          Text(subtitle)
            .font(.system(size: 11))
            .foregroundColor(.sublifyTextSecondary)
        }
      }

      Spacer()

      Toggle("", isOn: Binding(
        get: { isOn },
        set: { newValue in
          isOn = newValue
          onChange(newValue)
        }
      ))
        .toggleStyle(SublifyToggleStyle())
    }
    .padding(SublifySpacing.md)
    .background(Color.sublifyCardBackground)
  }
}

// MARK: - Preview Section
struct PreviewSection: View {
  @ObservedObject var sublifyManager: SublifyManager
  let testDisplay: () -> Void

  var body: some View {
    VStack(spacing: SublifySpacing.md) {
      HStack {
        Label {
          Text("Preview")
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.sublifyTextSecondary)
        } icon: {
          Image(systemName: "eye.fill")
            .foregroundColor(.sublifyTextSecondary)
            .font(.system(size: 11))
        }

        Spacer()
      }

      PreviewDisplay(sublifyManager: sublifyManager)

      Button(action: testDisplay) {
        HStack(spacing: SublifySpacing.sm) {
          Image(systemName: "play.fill")
            .font(.system(size: 12))
          Text("Test Full Display")
            .font(.sublifyButton)
        }
      }
      .frame(maxWidth: .infinity)
      .buttonStyle(SublifyPrimaryButtonStyle())
    }
    .padding(SublifySpacing.lg)
    .background(
      LinearGradient(
        colors: [Color.sublifyPrimary.opacity(0.03), Color.sublifySecondary.opacity(0.02)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
    .cornerRadius(SublifyRadius.lg)
    .overlay(
      RoundedRectangle(cornerRadius: SublifyRadius.lg)
        .stroke(Color.sublifyPrimary.opacity(0.2), lineWidth: 1)
    )
  }
}

// MARK: - Preview Display
struct PreviewDisplay: View {
  @ObservedObject var sublifyManager: SublifyManager

  var body: some View {
    ZStack {
      sublifyManager.settings.backgroundColor

      if sublifyManager.settings.useCustomImage {
        Text("Image Preview")
          .font(.system(size: CGFloat(sublifyManager.settings.fontSize)))
          .foregroundColor(.sublifyTextSecondary)
      } else {
        Text(sublifyManager.settings.motivationText)
          .font(.system(size: CGFloat(sublifyManager.settings.fontSize)))
          .foregroundColor(sublifyManager.settings.textColor)
          .multilineTextAlignment(.center)
          .padding()
      }
    }
    .frame(height: 120)
    .cornerRadius(SublifyRadius.lg)
    .overlay(
      RoundedRectangle(cornerRadius: SublifyRadius.lg)
        .stroke(Color.sublifyBorder.opacity(0.3), lineWidth: 1)
    )
  }
}

// MARK: - Compact Text Field Style
struct CompactTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .font(.system(size: 13, weight: .medium))
      .foregroundColor(.sublifyText)
      .padding(.horizontal, SublifySpacing.md)
      .padding(.vertical, SublifySpacing.sm)
      .background(Color.white)
      .cornerRadius(SublifyRadius.md)
      .shadow(color: Color.black.opacity(0.02), radius: 1, x: 0, y: 1)
  }
}

// MARK: - NSClickGestureRecognizer Extension
extension NSClickGestureRecognizer {
  convenience init(handler: @escaping (NSClickGestureRecognizer) -> Void) {
    self.init()
    self.target = self
    self.action = #selector(handleClick)
    objc_setAssociatedObject(self, &AssociatedKeys.handler, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }

  @objc private func handleClick() {
    if let handler = objc_getAssociatedObject(self, &AssociatedKeys.handler) as? (NSClickGestureRecognizer) -> Void {
      handler(self)
    }
  }
}

private struct AssociatedKeys {
  static var handler: UInt8 = 0
}
