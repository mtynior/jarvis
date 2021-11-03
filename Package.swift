// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Jarvis",
    products: [
        .library(name: "Jarvis", targets: ["Jarvis"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Jarvis", dependencies: [], path: "Sources"),
        .testTarget(name: "JarvisTests", dependencies: ["Jarvis"], path: "Tests")
    ]
)
