// swift-tools-version:5.2
import PackageDescription


let package = Package(
    name: "Swift Toolbox by Tricertops",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "SwiftToolboxLibrary",
            targets: ["SwiftToolboxTarget"]),
    ],
    targets: [
        .target(
            name: "SwiftToolboxTarget",
            path: "Sources/"),
    ]
)

