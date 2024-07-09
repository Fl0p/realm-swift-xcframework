// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Realm",
        platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "Realm",
            targets: ["Realm"]
        ),
        .library(
            name: "RealmSwift",
            targets: ["RealmSwift"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "Realm",
            path: "Realm.xcframework"
        ),
        .binaryTarget(
            name: "RealmSwift",
            path: "RealmSwift.xcframework"
        )
    ]
)