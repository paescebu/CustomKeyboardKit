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
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", exact: "1.1.1")
    ],
    targets: [
        .target(
            name: "CustomKeyboardKit",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect")
            ]),
    ]
)
