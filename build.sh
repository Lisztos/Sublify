#!/bin/bash

# Build script for Motivator macOS app

echo "🚀 Building Motivator app..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode command line tools are not installed."
    echo "Please install Xcode and run: xcode-select --install"
    exit 1
fi

# Build the app
echo "📦 Compiling Swift code..."
xcodebuild -project Motivator.xcodeproj -scheme Motivator -configuration Release build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📍 Your app is located at:"
    echo "   build/Release/Motivator.app"
    echo ""
    echo "🎯 To run the app:"
    echo "   open build/Release/Motivator.app"
    echo ""
    echo "📋 To install to Applications folder:"
    echo "   cp -R build/Release/Motivator.app /Applications/"
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi
