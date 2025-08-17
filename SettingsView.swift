import SwiftUI

struct SettingsView: View {
    @ObservedObject var motivatorManager: MotivatorManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section("Timing") {
                    HStack {
                        Text("Show every:")
                        Spacer()
                        TextField("Minutes", value: $motivatorManager.settings.intervalMinutes, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                        Text("minutes")
                    }

                    HStack {
                        Text("Display for:")
                        Spacer()
                        TextField("Milliseconds", value: $motivatorManager.settings.displayDurationMs, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                        Text("ms")
                    }
                }

                Section("Content") {
                    Toggle("Use custom image", isOn: $motivatorManager.settings.useCustomImage)

                    if motivatorManager.settings.useCustomImage {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Image path:")
                                Spacer()
                                Button("Browse") {
                                    showingImagePicker = true
                                }
                            }

                            TextField("Path to image file", text: $motivatorManager.settings.customImagePath)
                                .textFieldStyle(.roundedBorder)
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text("Motivation text:")
                            TextEditor(text: $motivatorManager.settings.motivationText)
                                .frame(height: 80)
                                .border(Color.gray.opacity(0.3))
                        }
                    }
                }

                Section("Appearance") {
                    HStack {
                        Text("Background color:")
                        Spacer()
                        Picker("Background", selection: $motivatorManager.settings.backgroundColor) {
                            Text("Blue").tag("blue")
                            Text("Green").tag("green")
                            Text("Purple").tag("purple")
                            Text("Orange").tag("orange")
                            Text("Red").tag("red")
                            Text("Black").tag("black")
                        }
                        .pickerStyle(.menu)
                    }

                    HStack {
                        Text("Text color:")
                        Spacer()
                        Picker("Text Color", selection: $motivatorManager.settings.textColor) {
                            Text("White").tag("white")
                            Text("Black").tag("black")
                            Text("Yellow").tag("yellow")
                            Text("Cyan").tag("cyan")
                        }
                        .pickerStyle(.menu)
                    }

                    HStack {
                        Text("Font size:")
                        Spacer()
                        TextField("Size", value: $motivatorManager.settings.fontSize, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                        Text("pt")
                    }
                }

                Section {
                    Button("Test Display") {
                        testDisplay()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        motivatorManager.saveSettings()
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 500, height: 600)
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
