// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WakeUpSamurai",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "WakeUpSamurai", targets: ["WakeUpSamurai"]),
        .library(name: "WakeUpSamuraiCore", targets: ["WakeUpSamuraiCore"])
    ],
    targets: [
        .target(name: "WakeUpSamuraiCore"),
        .executableTarget(
            name: "WakeUpSamurai",
            dependencies: ["WakeUpSamuraiCore"],
            linkerSettings: [
                .linkedFramework("IOKit")
            ]
        ),
        .testTarget(
            name: "WakeUpSamuraiCoreTests",
            dependencies: ["WakeUpSamuraiCore"]
        )
    ]
)
