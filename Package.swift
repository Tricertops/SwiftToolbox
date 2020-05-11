// swift-tools-version:5.2
//
//  Package.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import PackageDescription

private enum SwiftToolbox {
    static let packageName = "Swift Toolbox"
    static let libraryName = "Swift Toolbox"
    static let targetName = "SwiftToolbox"
}

let package = Package(
    name: SwiftToolbox.packageName,
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: SwiftToolbox.libraryName,
            targets: [
                SwiftToolbox.targetName,
        ]),
    ],
    targets: [
        .target(
            name: SwiftToolbox.targetName,
            path: "Sources/"),
    ]
)

