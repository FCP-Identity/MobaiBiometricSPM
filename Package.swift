// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MobaiBiometric",
    products: [
        .library(
            name: "MobaiBiometric",
            targets: ["MobaiBiometric"]),
    ],
    targets: [
        .binaryTarget(
            name: "MobaiBiometric",
            url: "https://github.com/FCP-Identity/MobaiBiometricSPM/releases/download/2.3.1/MobaiBiometric.xcframework.zip",
            checksum: "cace39099a40dda468e09820232f7d66d70a2c53c807af2c3657a4a036730460"

        ),
    ]
)
