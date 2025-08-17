import SwiftUI
import Foundation

class MotivatorManager: ObservableObject {
    @Published var isRunning = false
    @Published var settings = MotivatorSettings()

    private var timer: Timer?
    private var overlayWindow: NSWindow?

    init() {
        loadSettings()
    }

    func start() {
        guard !isRunning else { return }

        isRunning = true
        scheduleNext()
    }

    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        hideOverlay()
    }

    private func scheduleNext() {
        guard isRunning else { return }

        let interval = TimeInterval(settings.intervalMinutes * 60)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.showMotivation()
        }
    }

    private func showMotivation() {
        showOverlay()

        // Hide after specified duration
        let displayDuration = TimeInterval(settings.displayDurationMs) / 1000.0
        DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) { [weak self] in
            self?.hideOverlay()
            self?.scheduleNext() // Schedule next display
        }
    }

    private func showOverlay() {
        hideOverlay() // Ensure we don't have multiple overlays

        let screen = NSScreen.main ?? NSScreen.screens.first!
        let overlayView = OverlayView(settings: settings)

        overlayWindow = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        overlayWindow?.contentView = NSHostingView(rootView: overlayView)
        overlayWindow?.backgroundColor = NSColor.clear
        overlayWindow?.isOpaque = false
        overlayWindow?.level = .screenSaver
        overlayWindow?.ignoresMouseEvents = false
        overlayWindow?.makeKeyAndOrderFront(nil)

        // Add click-to-dismiss functionality
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(overlayClicked))
        overlayWindow?.contentView?.addGestureRecognizer(clickGesture)
    }

    @objc private func overlayClicked() {
        hideOverlay()
        scheduleNext()
    }

    private func hideOverlay() {
        overlayWindow?.orderOut(nil)
        overlayWindow = nil
    }

    func saveSettings() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(settings) {
            UserDefaults.standard.set(data, forKey: "MotivatorSettings")
        }
    }

    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "MotivatorSettings"),
           let savedSettings = try? JSONDecoder().decode(MotivatorSettings.self, from: data) {
            settings = savedSettings
        }
    }
}

struct MotivatorSettings: Codable {
    var intervalMinutes: Int = 30
    var displayDurationMs: Int = 3000
    var motivationText: String = "You're doing great! Keep going! 💪"
    var useCustomImage: Bool = false
    var customImagePath: String = ""
    var backgroundColor: String = "blue"
    var textColor: String = "white"
    var fontSize: Int = 48
}
