// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomKeyboardKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CustomKeyboardKit",
            targets: ["CustomKeyboardKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", branch: "master")
    ],
    targets: [
        .target(
            name: "CustomKeyboardKit",
            dependencies: [.product(name: "Introspect", package: "SwiftUI-Introspect")]),
    ]
)
