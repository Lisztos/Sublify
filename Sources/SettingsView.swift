import SwiftUI

struct SettingsView: View {
  @ObservedObject var sublifyManager: SublifyManager
  @Environment(\.dismiss) private var dismiss
  @State private var showingImagePicker = false

  var body: some View {
    VStack(spacing: 0) {
      // Clean Header
      VStack(spacing: SublifySpacing.md) {
        HStack {
          Button("Cancel") {
            dismiss()
          }
          .buttonStyle(SublifySecondaryButtonStyle())

          Spacer()

          Text("Settings")
            .font(.sublifyH2)
            .foregroundColor(.sublifyText)

          Spacer()

          Button("Save") {
            sublifyManager.saveSettings()
            dismiss()
          }
          .buttonStyle(SublifyPrimaryButtonStyle())
        }
      }
      .padding(SublifySpacing.lg)
      .background(Color.sublifyBackground)
      .overlay(
        Rectangle()
          .fill(Color.sublifyBorder)
          .frame(height: 1),
        alignment: .bottom
      )

      // Content
      ScrollView {
        VStack(alignment: .leading, spacing: SublifySpacing.lg) {
          // Timing Section
          SublifyModernCard {
            VStack(alignment: .leading, spacing: SublifySpacing.md) {
              Text("Timing")
                .font(.sublifyH3)
                .foregroundColor(.sublifyText)

              VStack(spacing: SublifySpacing.md) {
                HStack {
                  VStack(alignment: .leading, spacing: SublifySpacing.xs) {
                    Text("Show every:")
                      .font(.sublifyBody)
                      .foregroundColor(.sublifyText)
                    HStack {
                      TextField("Minutes", value: Binding(
                        get: { sublifyManager.settings.intervalMinutes },
                        set: { sublifyManager.settings.intervalMinutes = min(max($0, 1), 60) }
                      ), format: .number)
                        .textFieldStyle(SublifyTextFieldStyle())
                        .frame(width: 80)
                      Text("minutes")
                        .font(.sublifyBody)
                        .foregroundColor(.sublifyTextSecondary)
                    }
                  }
                  Spacer()
                }

                Text("(Max: 60 minutes)")
                  .font(.sublifyCaption)
                  .foregroundColor(.sublifyTextSecondary)
                  .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                  VStack(alignment: .leading, spacing: SublifySpacing.xs) {
                    Text("Display for:")
                      .font(.sublifyBody)
                      .foregroundColor(.sublifyText)
                    HStack {
                      TextField("Milliseconds", value: $sublifyManager.settings.displayDurationMs, format: .number)
                        .textFieldStyle(SublifyTextFieldStyle())
                        .frame(width: 80)
                      Text("ms")
                        .font(.sublifyBody)
                        .foregroundColor(.sublifyTextSecondary)
                    }
                  }
                  Spacer()
                }

                HStack(spacing: SublifySpacing.sm) {
                  Button("125ms (Recommended)") {
                    sublifyManager.settings.displayDurationMs = 125
                  }
                  .buttonStyle(SublifySecondaryButtonStyle())
                  .controlSize(.small)

                  Button("3000ms (Visible)") {
                    sublifyManager.settings.displayDurationMs = 3000
                  }
                  .buttonStyle(SublifySecondaryButtonStyle())
                  .controlSize(.small)

                  Spacer()
                }

                Text("125ms = Subliminal influence, 3000ms = Clearly visible")
                  .font(.sublifyCaption)
                  .foregroundColor(.sublifyTextSecondary)
                  .frame(maxWidth: .infinity, alignment: .leading)
              }
            }
          }

          // Content Section
          SublifyModernCard {
            VStack(alignment: .leading, spacing: SublifySpacing.md) {
              Text("Content")
                .font(.sublifyH3)
                .foregroundColor(.sublifyText)

              VStack(alignment: .leading, spacing: SublifySpacing.md) {
                Toggle("Use custom image", isOn: $sublifyManager.settings.useCustomImage)
                  .toggleStyle(SublifyToggleStyle())
                  .font(.sublifyBody)
                  .foregroundColor(.sublifyText)

                if sublifyManager.settings.useCustomImage {
                  VStack(alignment: .leading, spacing: SublifySpacing.sm) {
                    HStack {
                      Text("Image path:")
                        .font(.sublifyBody)
                        .foregroundColor(.sublifyText)
                      Spacer()
                      Button("Browse...") {
                        showingImagePicker = true
                      }
                      .buttonStyle(SublifySecondaryButtonStyle())
                      .controlSize(.small)
                    }

                    TextField("Select an image file using Browse button", text: $sublifyManager.settings.customImagePath)
                      .textFieldStyle(SublifyTextFieldStyle())
                      .disabled(true)
                  }
                } else {
                  VStack(alignment: .leading, spacing: SublifySpacing.sm) {
                    Text("Motivation text:")
                      .font(.sublifyBody)
                      .foregroundColor(.sublifyText)
                    TextEditor(text: $sublifyManager.settings.motivationText)
                      .font(.sublifyBody)
                      .frame(height: 100)
                      .padding(SublifySpacing.sm)
                      .background(Color.sublifyCardBackground)
                      .overlay(
                        RoundedRectangle(cornerRadius: SublifyRadius.md)
                          .stroke(Color.sublifyBorder, lineWidth: 1)
                      )
                      .cornerRadius(SublifyRadius.md)
                  }
                }
              }
            }
          }

          // Appearance Section
          SublifyModernCard {
            VStack(alignment: .leading, spacing: SublifySpacing.md) {
              Text("Appearance")
                .font(.sublifyH3)
                .foregroundColor(.sublifyText)

              VStack(spacing: SublifySpacing.md) {
                HStack {
                  Text("Background color:")
                    .font(.sublifyBody)
                    .foregroundColor(.sublifyText)
                    .frame(width: 120, alignment: .leading)
                  ColorPicker("", selection: $sublifyManager.settings.backgroundColor, supportsOpacity: false)
                    .frame(width: 100)
                  Spacer()
                }

                HStack {
                  Text("Text color:")
                    .font(.sublifyBody)
                    .foregroundColor(.sublifyText)
                    .frame(width: 120, alignment: .leading)
                  ColorPicker("", selection: $sublifyManager.settings.textColor, supportsOpacity: false)
                    .frame(width: 100)
                  Spacer()
                }

                HStack {
                  Text("Font size:")
                    .font(.sublifyBody)
                    .foregroundColor(.sublifyText)
                    .frame(width: 120, alignment: .leading)
                  TextField("Size", value: $sublifyManager.settings.fontSize, format: .number)
                    .textFieldStyle(SublifyTextFieldStyle())
                    .frame(width: 80)
                  Text("pt")
                    .font(.sublifyBody)
                    .foregroundColor(.sublifyTextSecondary)
                  Spacer()
                }
              }
            }
          }

          // Test Button
          Button("Test Display") {
            testDisplay()
          }
          .frame(maxWidth: .infinity)
          .buttonStyle(SublifyPrimaryButtonStyle())
          .controlSize(.large)
        }
        .padding(SublifySpacing.lg)
      }
    }
    .background(Color.sublifyBackground)
    .frame(width: 700, height: 800)
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
    // Temporarily show overlay for testing
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

    // Auto-dismiss after 2 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      testWindow.orderOut(nil)
    }

    // Add click-to-dismiss
    let clickGesture = NSClickGestureRecognizer { _ in
      testWindow.orderOut(nil)
    }
    testWindow.contentView?.addGestureRecognizer(clickGesture)
  }
}

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
  static var handler = "handler"
}