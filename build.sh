#!/bin/bash

# Build script for Sublify macOS app

echo "🚀 Building Sublify app..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode command line tools are not installed."
    echo "Please install Xcode and run: xcode-select --install"
    exit 1
fi

# Build the app
echo "📦 Compiling Swift code..."
xcodebuild -project Sublify.xcodeproj -scheme Sublify -configuration Release build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📍 Your app is located at:"
    echo "   build/Release/Sublify.app"
    echo ""
    echo "🎯 To run the app:"
    echo "   open build/Release/Sublify.app"
    echo ""
    echo "📋 To install to Applications folder:"
    echo "   cp -R build/Release/Sublify.app /Applications/"
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi
