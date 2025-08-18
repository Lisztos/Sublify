# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Sublify is a macOS desktop app built with SwiftUI that delivers personalized motivational messages using subliminal timing (125ms) or visible durations. The app runs as a background utility and displays fullscreen overlays with customizable text or images to boost productivity.

## Common Development Commands

### Building
```bash
# Build using Xcode project
xcodebuild -project Sublify.xcodeproj -scheme Sublify -configuration Release build

# Or use the provided build script
./build.sh

# Build using Swift Package Manager (development)
swift build

# Run directly with SPM
swift run
```

### Running & Testing
```bash
# Open built app
open build/Release/Sublify.app

# Install to Applications folder
cp -R build/Release/Sublify.app /Applications/

# Run from command line for debugging
./build/Release/Sublify
```

### Development Tools
```bash
# Format Swift code
swift-format --in-place --recursive Sources/

# Run Swift linter (if swiftlint is installed)
swiftlint

# Clean build artifacts
rm -rf .build build/
```

## Architecture Overview

### Core Components

**MotivatorManager** (`Sources/MotivatorManager.swift`)
- Central coordinator managing the motivation display system
- Handles timer scheduling, overlay management, and settings persistence
- Uses `Timer` for interval-based displays and `NSWindow` for fullscreen overlays
- Settings are persisted via `UserDefaults` with JSON encoding

**MotivatorSettings** (within `MotivatorManager.swift`)
- Codable struct storing all user preferences
- Key settings: display intervals, duration, text/image content, appearance
- Default subliminal duration is 125ms, but supports visible durations (2000-5000ms)

**OverlayView** (`Sources/OverlayView.swift`)
- SwiftUI view that renders the fullscreen motivational display
- Supports both text and custom image content
- Handles color themes, font sizing, and click-to-dismiss functionality
- Uses `.screenSaver` window level to appear above all content

**ContentView** (`Sources/ContentView.swift`)
- Main application interface showing status and controls
- Provides start/stop functionality and settings access
- Displays current configuration (interval, duration, status)

**SettingsView** (`Sources/SettingsView.swift`)
- Comprehensive settings interface with multiple sections:
  - Timing: interval (1-60 minutes) and display duration
  - Content: toggle between text and custom images
  - Appearance: background/text colors and font size
- Includes test functionality to preview displays

### App Structure Patterns

**Background Operation**
- App runs as LSUIElement (no dock icon) for minimal distraction
- Uses `NSApplicationDelegateAdaptor` for app lifecycle management
- Continues running when main window is closed

**Window Management**
- Main interface: Fixed-size window (300x250) with hidden title bar
- Overlay: Borderless fullscreen window with `.screenSaver` level
- Settings: Resizable sheet presentation (600x700)

**Timer & Scheduling**
- Uses `Timer.scheduledTimer` for interval-based displays
- Automatic rescheduling after each display completion
- Click-dismissal triggers immediate rescheduling

**File Handling**
- Custom images loaded via `NSImage(contentsOfFile:)`
- File selection through `fileImporter` with `.image` content types
- Sandboxed file access with read-only permissions

## Key Configuration Details

- **Target Platform**: macOS 13.0+ (Swift 5.9+)
- **Architecture**: Universal (Intel + Apple Silicon)
- **Sandboxing**: Enabled with user-selected file read permissions
- **App Category**: Background utility with fullscreen overlay capability
- **Build System**: Supports both Xcode projects and Swift Package Manager

## Development Notes

**SwiftUI Integration**
- Uses `@StateObject` for MotivatorManager binding
- Combines `NSWindow` management with SwiftUI views via `NSHostingView`
- Settings persistence through ObservableObject pattern

**macOS-Specific Features**
- Window level management for overlay display priority
- NSScreen handling for multi-monitor setups
- NSClickGestureRecognizer for overlay interaction

**User Experience Considerations**
- Subliminal timing (125ms) vs visible displays (2000-5000ms)
- Click-anywhere-to-dismiss for immediate user control
- Smooth animations with `.easeInOut` transitions
- Visual feedback through status indicators and test modes
