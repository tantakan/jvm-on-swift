// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "jvm-on-swift",
    targets: [
        .target(
            name: "jvm-on-swift",
            dependencies: []),
        .testTarget(
            name: "jvm-on-swiftTests",
            dependencies: ["jvm-on-swift"]),
    ]
)
