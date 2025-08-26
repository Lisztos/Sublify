#!/bin/bash

# Build script for Sublify macOS app
set -e

echo "🚀 Building Sublify app..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode command line tools are not installed."
    echo "Please install Xcode and run: xcode-select --install"
    exit 1
fi

# Create build directory
BUILD_DIR="build"
RELEASE_DIR="$BUILD_DIR/Release"
APP_NAME="Sublify.app"

echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build the app using xcodebuild
echo "📦 Compiling Swift code..."
xcodebuild \
    -project Sublify.xcodeproj \
    -scheme Sublify \
    -configuration Release \
    -derivedDataPath "$BUILD_DIR/DerivedData" \
    -archivePath "$BUILD_DIR/Sublify.xcarchive" \
    archive

echo "📱 Exporting app..."
xcodebuild \
    -archivePath "$BUILD_DIR/Sublify.xcarchive" \
    -exportPath "$BUILD_DIR" \
    -exportOptionsPlist exportOptions.plist

# Check if build was successful
if [ -d "$BUILD_DIR/$APP_NAME" ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📍 Your app is located at:"
    echo "   $BUILD_DIR/$APP_NAME"
    echo ""
    echo "🎯 To run the app:"
    echo "   open '$BUILD_DIR/$APP_NAME'"
    echo ""
    echo "📋 To install to Applications folder:"
    echo "   cp -R '$BUILD_DIR/$APP_NAME' /Applications/"
    echo ""
    echo "📦 To create a distributable ZIP:"
    echo "   cd $BUILD_DIR && zip -r Sublify-macOS.zip '$APP_NAME'"
else
    echo "❌ Build failed. App not found at expected location."
    exit 1
fi
