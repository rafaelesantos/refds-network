// swift-tools-version: 5.4
// swift-tools-version: 5.5
// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RefdsNetwork",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7),
    ],
    products: [
        .library(
            name: "RefdsNetwork",
            targets: ["RefdsNetwork"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RefdsNetwork",
            dependencies: []
        ),
        .testTarget(
            name: "RefdsNetworkTests",
            dependencies: ["RefdsNetwork"]
        ),
    ]
)
