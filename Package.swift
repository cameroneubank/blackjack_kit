// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "BlackjackKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "BlackjackKit",
            targets: ["BlackjackKit"])
    ],
    dependencies: [
        .package(name: "CardKit",
                 url: "https://github.com/cameroneubank/card_kit.git",
                 from: "0.1.0")
    ],
    targets: [
        .target(
            name: "BlackjackKit",
            dependencies: ["CardKit"]),
        .testTarget(
            name: "BlackjackKitTests",
            dependencies: ["BlackjackKit", "CardKit"])
    ]
)

