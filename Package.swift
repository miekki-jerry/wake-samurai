// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WakeSamurai",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "WakeSamurai", targets: ["WakeSamurai"]),
        .library(name: "WakeSamuraiCore", targets: ["WakeSamuraiCore"])
    ],
    targets: [
        .target(name: "WakeSamuraiCore"),
        .executableTarget(
            name: "WakeSamurai",
            dependencies: ["WakeSamuraiCore"],
            linkerSettings: [
                .linkedFramework("IOKit")
            ]
        ),
        .testTarget(
            name: "WakeSamuraiCoreTests",
            dependencies: ["WakeSamuraiCore"]
        )
    ]
)
