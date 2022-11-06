// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PaperClip",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "RemoteStore", targets: ["RemoteStore"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "RemoteStore"),
        .testTarget(name: "RemoteStoreTests",
                    dependencies: ["RemoteStore"],
                    resources: [.copy("Stub")])
    ]
)
