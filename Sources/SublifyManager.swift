import SwiftUI
import Foundation

class SublifyManager: ObservableObject {
  @Published var isRunning = false
  @Published var settings = SublifySettings()

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
      UserDefaults.standard.set(data, forKey: "SublifySettings")
    }
  }

  private func loadSettings() {
    if let data = UserDefaults.standard.data(forKey: "SublifySettings"),
       let savedSettings = try? JSONDecoder().decode(SublifySettings.self, from: data) {
      settings = savedSettings
    }
  }
}

struct SublifySettings: Codable {
  var intervalMinutes: Int = 1
  var displayDurationMs: Int = 125
  var motivationText: String = "You're great!"
  var useCustomImage: Bool = false
  var customImagePath: String = ""
  var backgroundColorData: Data = Color.black.colorData
  var textColorData: Data = Color.white.colorData
  var fontSize: Int = 70

  // Computed properties for easy access to Color objects
  var backgroundColor: Color {
    get { Color.fromData(backgroundColorData) ?? Color.blue }
    set { backgroundColorData = newValue.colorData }
  }

  var textColor: Color {
    get { Color.fromData(textColorData) ?? Color.white }
    set { textColorData = newValue.colorData }
  }
}

// Extension to handle Color encoding/decoding
extension Color {
  var colorData: Data {
    let nsColor = NSColor(self)
    return try! NSKeyedArchiver.archivedData(withRootObject: nsColor, requiringSecureCoding: false)
  }

  static func fromData(_ data: Data) -> Color? {
    guard let nsColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else {
      return nil
    }
    return Color(nsColor)
  }
}
