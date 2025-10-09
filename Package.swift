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
            url: "https://downloads.mobai.dev/releases/ios/2.3.1/MobaiBiometric.xcframework.zip",
            checksum: "a11dde7b21225a2200fa0d955b26c672ba9c0fcec5ac5297e9caa47ba69a519d"

        ),
    ]
)
