// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coordinator",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Coordinator",
            targets: ["Coordinator"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/EtneteraMobile/CombineExtensions", branch: "main"),
        .package(url: "https://github.com/CombineCommunity/CombineExt", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Coordinator",
            dependencies: [
                "CombineExtensions",
                "CombineExt"
            ]
        ),
        .testTarget(
            name: "CoordinatorTests",
            dependencies: ["Coordinator"]
        )
    ]
)
