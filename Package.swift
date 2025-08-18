// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Sublify",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Sublify", targets: ["Sublify"])
    ],
    targets: [
        .executableTarget(
            name: "Sublify",
            path: "Sources"
        )
    ]
)
