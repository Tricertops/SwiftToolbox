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
            name: "Swift Toolbox",
            targets: ["Toolbox"]),
    ],
    targets: [
        .target(
            name: "Toolbox",
            path: "Sources/"),
    ]
)

