#!/bin/bash

# Build script for Subliminal Motivator macOS app

echo "🚀 Building Subliminal Motivator app..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode command line tools are not installed."
    echo "Please install Xcode and run: xcode-select --install"
    exit 1
fi

# Build the app
echo "📦 Compiling Swift code..."
xcodebuild -project SubliminalMotivator.xcodeproj -scheme SubliminalMotivator -configuration Release build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📍 Your app is located at:"
    echo "   build/Release/SubliminalMotivator.app"
    echo ""
    echo "🎯 To run the app:"
    echo "   open build/Release/SubliminalMotivator.app"
    echo ""
    echo "📋 To install to Applications folder:"
    echo "   cp -R build/Release/SubliminalMotivator.app /Applications/"
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi
