// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "turboAgent",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "turboagent", targets: ["turboAgent"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "turboAgent",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "turboAgentTests",
            dependencies: ["turboAgent"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
