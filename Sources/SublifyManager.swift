import SwiftUI
import Foundation
import Combine

class SublifyManager: ObservableObject {
  @Published var isRunning = false
  @Published var settings: SublifySettings

  private var timer: Timer?
  private var overlayWindow: NSWindow?
  private var cancellables = Set<AnyCancellable>()
  private var statusItem: NSStatusItem?

  init() {
    // Initialize with default settings first
    self.settings = SublifySettings()
    
    // Load saved settings
    loadSettings()
    
    // Set up automatic saving when settings change
    setupAutoSave()
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
  
  private func setupAutoSave() {
    // Listen for changes to the settings and automatically save them
    $settings
      .dropFirst() // Skip the initial value to avoid saving during initialization
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main) // Debounce to avoid excessive saving
      .sink { [weak self] _ in
        self?.saveSettings()
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Menu Bar Management
  func setupMenuBar() {
    guard settings.showInMenuBar else {
      removeMenuBar()
      return
    }
    
    if statusItem == nil {
      statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    }
    
    guard let statusItem = statusItem else { return }
    
    // Set the status item icon
    if let button = statusItem.button {
      // Try to get the app icon first
      if let appIcon = NSApp.applicationIconImage {
        let resizedIcon = appIcon.resized(to: NSSize(width: 18, height: 18))
        button.image = resizedIcon
      } else {
        // Fallback to SF Symbol
        button.image = NSImage(systemSymbolName: "app.fill", accessibilityDescription: "Sublify")
      }
      
      button.toolTip = "Sublify - Subliminal Motivation"
    }
    
    // Create menu
    let menu = NSMenu()
    
    // Status info
    let statusMenuItem = NSMenuItem()
    statusMenuItem.title = isRunning ? "Status: Active" : "Status: Inactive"
    statusMenuItem.isEnabled = false
    menu.addItem(statusMenuItem)
    
    menu.addItem(NSMenuItem.separator())
    
    // Start/Stop toggle
    let toggleItem = NSMenuItem(
      title: isRunning ? "Stop" : "Start",
      action: #selector(toggleFromMenuBar),
      keyEquivalent: ""
    )
    toggleItem.target = self
    menu.addItem(toggleItem)
    
    menu.addItem(NSMenuItem.separator())
    
    // Show main window
    let showWindowItem = NSMenuItem(
      title: "Show Sublify",
      action: #selector(showMainWindow),
      keyEquivalent: ""
    )
    showWindowItem.target = self
    menu.addItem(showWindowItem)
    
    menu.addItem(NSMenuItem.separator())
    
    // Quit
    let quitItem = NSMenuItem(
      title: "Quit Sublify",
      action: #selector(quitApp),
      keyEquivalent: "q"
    )
    quitItem.target = self
    menu.addItem(quitItem)
    
    self.statusItem?.menu = menu
  }
  
  func removeMenuBar() {
    if let statusItem = statusItem {
      NSStatusBar.system.removeStatusItem(statusItem)
      self.statusItem = nil
    }
  }
  
  @objc private func toggleFromMenuBar() {
    if isRunning {
      stop()
    } else {
      start()
    }
    setupMenuBar() // Refresh menu
  }
  
  @objc private func showMainWindow() {
    NSApp.activate(ignoringOtherApps: true)
    
    // Find and show the main window
    for window in NSApp.windows {
      if window.contentViewController?.view.subviews.first is NSHostingView<ContentView> ||
         window.title.isEmpty { // Main window typically has no title due to hidden title bar
        window.makeKeyAndOrderFront(nil)
        break
      }
    }
  }
  
  @objc private func quitApp() {
    stop()
    removeMenuBar()
    NSApp.terminate(nil)
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
  var showInMenuBar: Bool = true
  var hideFromDock: Bool = false

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

// Extension to handle NSImage resizing for menu bar
extension NSImage {
  func resized(to newSize: NSSize) -> NSImage {
    let newImage = NSImage(size: newSize)
    newImage.lockFocus()
    self.draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height),
              from: NSRect.zero,
              operation: .sourceOver,
              fraction: 1.0)
    newImage.unlockFocus()
    return newImage
  }
}
