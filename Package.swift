// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HTTPRequestBuilder",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "HTTPRequestBuilder",
      targets: ["HTTPRequestBuilder"]
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "HTTPRequestBuilder"
    ),
    .testTarget(
      name: "HTTPRequestBuilderTests",
      dependencies: ["HTTPRequestBuilder"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
