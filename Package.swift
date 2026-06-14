// swift-tools-version:5.9
//
//  Package.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import PackageDescription

private enum Tricertops {
    static let packageName = "Swift Toolbox"
    static let libraryName = "Swift Toolbox by Tricertops"
    static let targetName = "Tricertops"
}

let package = Package(
    name: Tricertops.packageName,
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
    ],
    products: [
        .library(
            name: Tricertops.libraryName,
            targets: [
                Tricertops.targetName,
        ]),
    ],
    targets: [
        .target(
            name: Tricertops.targetName,
            path: "Sources/"),
    ]
)

