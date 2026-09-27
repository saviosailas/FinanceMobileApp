// swift-tools-version: 6.1
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
    name: "FinanceMobileApp",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "FinanceTracker", type: .dynamic, targets: ["FinanceTracker"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.9.5"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.0.0"),
        .package(url: "https://github.com/skiptools/skip-sql.git", from: "0.16.0")
    ],
    targets: [
        .target(
            name: "FinanceTracker",
            dependencies: [
                .product(name: "SkipUI", package: "skip-ui"),
                .product(name: "SkipSQL", package: "skip-sql")
            ],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "skipstone", package: "skip")]
        ),
        .testTarget(name: "FinanceTrackerTests", dependencies: [
            "FinanceTracker",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
