// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PaperClip",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "RemoteStore", targets: ["RemoteStore"]),
        .library(name: "Repository", targets: ["Repository"])
    ],
    dependencies: [
    ],
    targets: [
        //Domain
        .target(name: "Domain"),
        //RemoteStore
        .target(name: "RemoteStore",
                dependencies: ["Domain"]),
        .testTarget(name: "RemoteStoreTests",
                    dependencies: ["RemoteStore"],
                    resources: [.copy("Stub")]),
        //Repository
        .target(name: "Repository",
                dependencies: ["Domain"]),
        .testTarget(name: "RepositoryTests",
                    dependencies: ["Repository"])
    ]
)
