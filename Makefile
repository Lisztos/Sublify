# Makefile for Sublify macOS App

.PHONY: build clean install run archive release help

# Default target
help:
	@echo "🚀 Sublify Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  build     - Build the app for development"
	@echo "  release   - Build optimized release version"
	@echo "  clean     - Clean build artifacts"
	@echo "  install   - Install app to /Applications"
	@echo "  run       - Build and run the app"
	@echo "  archive   - Create distributable ZIP"
	@echo "  help      - Show this help message"

# Build for development
build:
	@echo "🔨 Building Sublify (Debug)..."
	@xcodebuild -project Sublify.xcodeproj -scheme Sublify -configuration Debug build

# Build optimized release
release:
	@echo "🚀 Building Sublify (Release)..."
	@./build.sh

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf DerivedData/
	@xcodebuild clean -project Sublify.xcodeproj -scheme Sublify

# Install to Applications folder
install: release
	@echo "📱 Installing to Applications..."
	@cp -R build/Sublify.app /Applications/
	@echo "✅ Installed to /Applications/Sublify.app"

# Build and run
run: build
	@echo "🎯 Launching Sublify..."
	@open build/Debug/Sublify.app

# Create distributable archive
archive: release
	@echo "📦 Creating distributable archive..."
	@cd build && zip -r Sublify-macOS.zip Sublify.app
	@echo "✅ Created build/Sublify-macOS.zip"

# Check requirements
check:
	@echo "🔍 Checking build requirements..."
	@command -v xcodebuild >/dev/null 2>&1 || { echo "❌ Xcode not found. Please install Xcode."; exit 1; }
	@echo "✅ Xcode found"
	@sw_vers -productName
	@sw_vers -productVersion
