// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWEmojiTextField",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "WWEmojiTextField", targets: ["WWEmojiTextField"]),
    ],
    targets: [
        .target(name: "WWEmojiTextField"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
