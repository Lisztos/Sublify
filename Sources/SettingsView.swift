import SwiftUI

struct SettingsView: View {
    @ObservedObject var motivatorManager: MotivatorManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)

                Spacer()

                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button("Save") {
                    motivatorManager.saveSettings()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                                                    // Timing Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Timing")
                            .font(.headline)
                            .foregroundColor(.primary)

                        VStack(spacing: 8) {
                            HStack {
                                Text("Show every:")
                                    .frame(width: 120, alignment: .leading)
                                TextField("Minutes", value: $motivatorManager.settings.intervalMinutes, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 80)
                                Text("minutes")
                                Spacer()
                            }

                            HStack {
                                Text("Display for:")
                                    .frame(width: 120, alignment: .leading)
                                TextField("Milliseconds", value: $motivatorManager.settings.displayDurationMs, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 80)
                                Text("ms")
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }

                                    // Content Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Content")
                            .font(.headline)
                            .foregroundColor(.primary)

                        VStack(alignment: .leading, spacing: 12) {
                            Toggle("Use custom image", isOn: $motivatorManager.settings.useCustomImage)

                            if motivatorManager.settings.useCustomImage {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Image path:")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Button("Browse...") {
                                            showingImagePicker = true
                                        }
                                        .buttonStyle(.bordered)
                                    }

                                    TextField("Select an image file using Browse button", text: $motivatorManager.settings.customImagePath)
                                        .textFieldStyle(.roundedBorder)
                                        .disabled(true)
                                }
                            } else {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Motivation text:")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    TextEditor(text: $motivatorManager.settings.motivationText)
                                        .frame(height: 100)
                                        .padding(4)
                                        .background(Color(.textBackgroundColor))
                                        .cornerRadius(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }

                                    // Appearance Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Appearance")
                            .font(.headline)
                            .foregroundColor(.primary)

                        VStack(spacing: 8) {
                            HStack {
                                Text("Background color:")
                                    .frame(width: 120, alignment: .leading)
                                Picker("Background", selection: $motivatorManager.settings.backgroundColor) {
                                    Text("Blue").tag("blue")
                                    Text("Green").tag("green")
                                    Text("Purple").tag("purple")
                                    Text("Orange").tag("orange")
                                    Text("Red").tag("red")
                                    Text("Black").tag("black")
                                }
                                .pickerStyle(.menu)
                                .frame(width: 100)
                                Spacer()
                            }

                            HStack {
                                Text("Text color:")
                                    .frame(width: 120, alignment: .leading)
                                Picker("Text Color", selection: $motivatorManager.settings.textColor) {
                                    Text("White").tag("white")
                                    Text("Black").tag("black")
                                    Text("Yellow").tag("yellow")
                                    Text("Cyan").tag("cyan")
                                }
                                .pickerStyle(.menu)
                                .frame(width: 100)
                                Spacer()
                            }

                            HStack {
                                Text("Font size:")
                                    .frame(width: 120, alignment: .leading)
                                TextField("Size", value: $motivatorManager.settings.fontSize, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 80)
                                Text("pt")
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }

                                    // Test Button
                    Button("Test Display") {
                        testDisplay()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
            }
        }
        .frame(width: 600, height: 700)
        .fileImporter(
            isPresented: $showingImagePicker,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                if let file = files.first {
                    motivatorManager.settings.customImagePath = file.path
                }
            case .failure(let error):
                print("Error selecting image: \(error)")
            }
        }
    }

    private func testDisplay() {
        // Temporarily show overlay for testing
        let screen = NSScreen.main ?? NSScreen.screens.first!
        let overlayView = OverlayView(settings: motivatorManager.settings)

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
