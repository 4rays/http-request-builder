// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HTTPRequestBuilder",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "HTTPRequestBuilder",
      targets: ["HTTPRequestBuilder"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-http-types.git", from: "1.3.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "HTTPRequestBuilder",
      dependencies: [
        .product(name: "HTTPTypes", package: "swift-http-types")
      ]
    ),
    .testTarget(
      name: "HTTPRequestBuilderTests",
      dependencies: ["HTTPRequestBuilder"]
    ),
  ]
)
