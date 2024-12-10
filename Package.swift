// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodablePlus",
    platforms: [
        .macOS(.v12),
        .macCatalyst(.v15),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
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
