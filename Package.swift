// swift-tools-version:5.2
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
    static let playgroundName = "Playground"
}

let package = Package(
    name: Tricertops.packageName,
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: Tricertops.libraryName,
            targets: [
                Tricertops.targetName,
        ]),
        .executable(
            name: Tricertops.playgroundName,
            targets: [
                Tricertops.playgroundName,
        ])
    ],
    targets: [
        .target(
            name: Tricertops.targetName,
            path: "Sources/"),
        .target(
            name: Tricertops.playgroundName,
            dependencies: [
                .target(name: Tricertops.targetName),
            ],
            path: "Playground/"),
    ]
)

