// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    dependencies: [
        .package(path: "../AppModules"),
        .package(path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: [
                "AppModules",
                "Domain"
            ]),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]),
    ]
)
