// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    products: [
        .library(
            name: "Common",
            targets: ["Common"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                "Domain"
            ]),
        .testTarget(
            name: "CommonTests",
            dependencies: ["Common"]),
    ]
)
