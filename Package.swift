// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AbramId",
    products: [
        .executable(name: "AbramId", targets: ["AbramId"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "AbramId",
            dependencies: ["Publish"]
        )
    ]
)