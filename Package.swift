// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleController",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SimpleController",
            targets: ["SimpleController"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        
        // 💧 A server-side Swift web framework.
        // Vapor
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        
        // Fluent
        .package(url: "https://github.com/vapor/fluent.git", from: "3.0.0"),
        
        // FluentSQLite, used for tests.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),


    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SimpleController",
            dependencies: ["Vapor", "Fluent"]),
        .testTarget(
            name: "SimpleControllerTests",
            dependencies: ["SimpleController", "FluentSQLite"]),
    ]
)
