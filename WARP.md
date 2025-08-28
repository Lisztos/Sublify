# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Sublify is a macOS desktop app built with SwiftUI that delivers personalized motivational messages using subliminal timing (125ms) or visible durations. The app empowers users to reclaim their minds from negative subliminal influences by providing positive, customizable messaging overlays. It runs as a background utility and displays fullscreen overlays with customizable text or images to boost productivity and mental well-being.

## Common Development Commands

### Building
```bash
# Build using Xcode project (Release)
xcodebuild -project Sublify.xcodeproj -scheme Sublify -configuration Release build

# Build using the provided build script (recommended for releases)
./build.sh

# Build using Swift Package Manager (development)
swift build

# Run directly with SPM (development)
swift run

# Build using Makefile
make build      # Debug build
make release    # Release build using build.sh
```

### Running & Testing
```bash
# Open built app (Release)
open build/Sublify.app

# Install to Applications folder
cp -R build/Sublify.app /Applications/

# Launch from Applications after install
open /Applications/Sublify.app

# Build and run (Debug)
make run
```

### Development Tools
```bash
# Clean build artifacts
make clean
# OR
rm -rf build/ DerivedData/
xcodebuild clean -project Sublify.xcodeproj -scheme Sublify

# Create distributable archive
make archive

# Check build requirements
make check
```

## Architecture Overview

### Core Components

**SublifyApp** (`Sources/SublifyApp.swift`)
- Main app entry point using `@main` attribute
- Configures window style with hidden title bar and content-based resizing
- `AppDelegate` handles app lifecycle and icon management
- Currently runs as `.regular` app (shows in dock) for testing purposes

**SublifyManager** (`Sources/SublifyManager.swift`)
- Central coordinator managing the motivation display system
- Handles timer scheduling, overlay management, and settings persistence
- Uses `Timer.scheduledTimer` for interval-based displays
- Creates fullscreen `NSWindow` overlays with `.screenSaver` level
- Auto-saves settings with debounced persistence using Combine
- Manages click-to-dismiss functionality

**SublifySettings** (within `SublifyManager.swift`)
- Codable struct storing all user preferences
- Key settings: intervalMinutes (1-60), displayDurationMs, motivationText
- Image support: useCustomImage toggle and customImagePath
- Color customization: backgroundColor, textColor with Data encoding
- Font size customization (default 70pt)
- Computed properties for easy Color object access

**ContentView** (`Sources/ContentView.swift`)
- Main application interface (450x550 window)
- Modern design with clean background and centered layout
- Shows app status with activity badges (Active/Inactive)
- Statistics display for interval and duration settings
- Primary action button for start/stop functionality
- Settings sheet presentation
- Uses comprehensive design system components

**OverlayView** (`Sources/OverlayView.swift`)
- SwiftUI view rendering fullscreen motivational displays
- Modern gradient background with brand colors
- Supports both text and custom image content with fallback
- Advanced text styling with background blur effects
- Dismiss instruction UI with tap icon and text
- Smooth animations and modern visual effects
- Click-anywhere-to-dismiss functionality

**SettingsView** (`Sources/SettingsView.swift`)
- Comprehensive settings interface (560x720 modal)
- Modular component architecture with dedicated sections:
  - `TimingSection`: Interval and duration with preset buttons
  - `ContentSection`: Text/image toggle with editor and file picker
  - `AppearanceSection`: Color pickers and font size controls
  - `PreviewSection`: Live preview and test display functionality
- Modern header with gradient background
- Interactive timing presets (Subliminal: 125ms, Brief: 500ms, Visible: 3000ms)
- File picker integration for custom images
- Real-time preview updates

**SublifyDesignSystem** (`Sources/SublifyDesignSystem.swift`)
- Comprehensive design system with modern styling
- Color palette: Purple/violet primary colors with semantic variants
- Typography system: H1-H4 headings, body text, captions
- Spacing system: xs(4) to xxl(48) consistent spacing
- Custom button styles: Primary gradient, secondary outlined
- Custom toggle, text field, and card components
- Shadow system with multiple levels
- Status badge components with color coding

### App Structure Patterns

**Modern SwiftUI Architecture**
- Uses `@StateObject` for SublifyManager binding
- Sheet-based navigation for settings
- Combine integration for reactive programming
- Modern component composition patterns

**Background Operation**
- Configured as LSUIElement in Info.plist (no dock icon in production)
- Currently set to `.regular` in AppDelegate for development
- Continues running when main window is closed
- Uses `NSApplicationDelegateAdaptor` for app lifecycle

**Window Management**
- Main interface: Fixed 450x550 window with hidden title bar
- Overlay: Borderless fullscreen window with `.screenSaver` level
- Settings: 560x720 modal sheet with rounded corners and shadow
- Multi-monitor support through NSScreen handling

**Timer & Scheduling**
- Uses `Timer.scheduledTimer` for precise interval timing
- Automatic rescheduling after each display completion
- Click-dismissal triggers immediate rescheduling
- Proper timer cleanup on app stop

**File Handling & Persistence**
- Custom images loaded via `NSImage(contentsOfFile:)`
- File selection through `fileImporter` with `.image` content types
- Settings persisted to UserDefaults with JSON encoding
- Auto-save with 500ms debounce using Combine
- Color encoding/decoding through NSKeyedArchiver

**Advanced UI Features**
- Hover states with cursor management (hand pointer)
- Smooth animations with easing curves
- Modern gradient backgrounds and blur effects
- Interactive preset selection with visual feedback
- Real-time character counting and validation

## Key Configuration Details

- **Target Platform**: macOS 13.0+ (Swift 5.9+)
- **Window Dimensions**: Main (450x550), Settings (560x720)
- **Bundle Configuration**: LSUIElement enabled for background operation
- **Sandboxing**: Enabled with user-selected file read permissions
- **App Category**: Productivity/Background utility with subliminal messaging
- **Build System**: Dual support - Xcode projects and Swift Package Manager
- **Architecture**: Universal (Intel + Apple Silicon)

## Development Notes

**Modern SwiftUI Patterns**
- Component-based architecture with reusable design system
- Reactive programming with Combine publishers
- Proper state management with ObservableObject
- Advanced styling with custom button and component styles
- Smooth animations and transitions throughout

**macOS-Specific Integration**
- Window level management for overlay display priority
- NSScreen API for multi-monitor support
- NSClickGestureRecognizer for custom interaction handling
- NSHostingView for SwiftUI/AppKit bridge
- App icon management through NSApplication

**User Experience Considerations**
- Research-backed timing: Subliminal (125ms), Brief (500ms), Visible (3000ms)
- Click-anywhere-to-dismiss for immediate user control
- Modern visual design with consistent spacing and typography
- Accessibility through high contrast and clear visual hierarchy
- Test functionality for immediate feedback on settings changes

**Performance & Quality**
- Debounced auto-saving to prevent excessive UserDefaults writes
- Proper memory management with weak references
- Clean component separation for maintainability
- Comprehensive error handling for file operations
- Modern Swift patterns with optionals and error handling

## Research Foundation

Sublify is built on solid psychological and neuroscientific research:

- **13ms Processing**: MIT research shows brain processes images in 13ms
- **125ms Threshold**: Below conscious awareness (~150-200ms)
- **Subliminal Priming**: Creates lasting neural changes and improved recognition
- **Neuroplasticity**: Repetitive positive exposure strengthens beneficial neural pathways
- **Breaking Negative Loops**: Interrupts unconscious negative self-talk patterns

## Project Structure

```
Sublify/
├── Sources/
│   ├── SublifyApp.swift           # App entry point and delegate
│   ├── SublifyManager.swift       # Core business logic and settings
│   ├── ContentView.swift          # Main UI interface
│   ├── OverlayView.swift          # Fullscreen message display
│   ├── SettingsView.swift         # Comprehensive settings interface
│   └── SublifyDesignSystem.swift  # Design system and styling
├── Assets.xcassets/               # App icons and image assets
├── .github/workflows/             # GitHub Actions for CI/CD
├── Sublify.xcodeproj/            # Xcode project configuration
├── Package.swift                  # Swift Package Manager config
├── Info.plist                    # App configuration and permissions
├── Sublify.entitlements          # App sandbox permissions
├── build.sh                      # Automated build script
├── Makefile                      # Build automation with targets
├── exportOptions.plist           # Export configuration for distribution
├── README.md                     # User documentation and features
├── RESEARCH.md                   # Research contribution guidelines
├── CONTRIBUTING.md               # Development contribution guide
└── LICENSE                       # MIT license
```

## Key Files Explained

- **build.sh**: Complete build pipeline with archiving and export
- **Makefile**: Development shortcuts (build, clean, install, run, archive)
- **Info.plist**: Configures LSUIElement for background operation
- **Sublify.entitlements**: Sandbox permissions for file access
- **exportOptions.plist**: Distribution settings for app store or direct distribution
- **Package.swift**: Minimal SPM config for development builds
- **Assets.xcassets/**: Contains app icon in multiple resolutions (16x16 to 512x512)

## Git Workflow

The project uses GitHub Actions for automated building and releases:
- **release.yml**: Builds and publishes releases when tags are pushed
- Issues templates for bug reports and feature requests
- Discussions enabled for community engagement and research contributions
