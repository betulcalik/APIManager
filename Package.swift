// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIManager",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "APIManager",
            targets: ["APIManager"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "APIManager",
            dependencies: ["KeychainAccess"]),
        .testTarget(
            name: "APIManagerTests",
            dependencies: ["APIManager",
                           "KeychainAccess"]),
    ]
)
