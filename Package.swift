// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Motivator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Motivator", targets: ["Motivator"])
    ],
    targets: [
        .executableTarget(
            name: "Motivator",
            path: "Sources"
        )
    ]
)
