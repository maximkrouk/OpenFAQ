// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "OpenFAQ",
    platforms: [
       .macOS(.v10_14)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0-beta"),
        .package(url: "https://github.com/MakeupStudio/VaporMakeup.git", from: "0.1.3"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "4.1.1")
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Fluent", 
            "FluentPostgresDriver",
            "Vapor",
            "VaporMakeup",
            "Files"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "XCTVapor"])
    ]
)
