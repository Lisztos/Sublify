import SwiftUI

@main
struct SublifyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Show dock icon for testing
        NSApp.setActivationPolicy(.regular)

        // Set the app icon programmatically
        setAppIcon()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool {
        return false
    }

    private func setAppIcon() {
        // Try to load the icon from multiple possible locations
        let iconPaths = [
            "Sources/app-icon.png",
            "./Sources/app-icon.png",
            "Assets/Branding/images/sublify-app-logo.png",
            "./Assets/Branding/images/sublify-app-logo.png"
        ]

        for iconPath in iconPaths {
            if let image = NSImage(contentsOfFile: iconPath) {
                NSApp.applicationIconImage = image
                print("✅ App icon set successfully from: \(iconPath)")
                return
            }
        }

        // If file paths don't work, try to find it in the bundle
        if let iconURL = Bundle.main.url(forResource: "app-icon", withExtension: "png"),
           let image = NSImage(contentsOf: iconURL) {
            NSApp.applicationIconImage = image
            print("✅ App icon set successfully from bundle")
            return
        }

        print("⚠️ Could not find app icon file")
    }
}
