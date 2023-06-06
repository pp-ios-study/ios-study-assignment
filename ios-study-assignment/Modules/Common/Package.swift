// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]),
    ],
    dependencies: [
        .package(path: "../AppModules"),
        .package(path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                "AppModules",
                "Domain"
            ]),
        .testTarget(
            name: "CommonTests",
            dependencies: ["Common"]),
    ]
)
