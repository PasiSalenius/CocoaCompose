// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocoaCompose",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "CocoaCompose", targets: ["CocoaCompose"]),
    ],
    targets: [
        .target(
            name: "CocoaCompose"),
        .testTarget(
            name: "CocoaComposeTests",
            dependencies: ["CocoaCompose"]),
    ]
)
