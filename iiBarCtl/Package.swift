// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "iiBarCtl",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(name: "iiBarCtl"),
    ]
)
