// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TogetherCore",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "TogetherCore",
            targets: ["TogetherCore"]
        ),
    ],
    dependencies: [
        .package(path: "TogetherNetwork"),
        .package(path: "TogetherFoundation"),
        .package(path: "../ThirdParty"),
    ],
    targets: [
        .target(
            name: "TogetherCore",
            dependencies: [
                .product(name: "TogetherNetwork", package: "TogetherNetwork"),
                .product(name: "TogetherFoundation", package: "TogetherFoundation"),
                .product(name: "ThirdParty", package: "ThirdParty"),
            ]
        ),
        .testTarget(
            name: "TogetherCoreTests",
            dependencies: ["TogetherCore"]
        ),
    ]
)
