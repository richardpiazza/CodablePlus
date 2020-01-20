// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodablePlus",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3),
    ],
    products: [
        .library(
            name: "CodablePlus",
            targets: ["CodablePlus"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "CodablePlus",
            dependencies: []),
        .testTarget(
            name: "CodablePlusTests",
            dependencies: ["CodablePlus"]),
    ],
    swiftLanguageVersions: [.v5]
)
