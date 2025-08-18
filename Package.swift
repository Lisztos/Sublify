// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SubliminalMotivator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "SubliminalMotivator", targets: ["SubliminalMotivator"])
    ],
    targets: [
        .executableTarget(
            name: "SubliminalMotivator",
            path: "Sources"
        )
    ]
)
