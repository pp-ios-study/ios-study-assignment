// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]),
    ],
    dependencies: [
        .package(path: "../AppModules")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                "AppModules"
            ]),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]),
    ]
)
