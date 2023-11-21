// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Novita",
  platforms: [
    .macOS(.v14)
  ],
  products: [
    .library(
      name: "Novita",
      targets: ["Novita"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-openapi-generator",
      branch: "main"
    ),
    .package(
      url: "https://github.com/apple/swift-openapi-runtime",
      branch: "main"
    ),
    .package(
      url: "https://github.com/swift-server/swift-openapi-async-http-client",
      branch: "main"
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Novita",
      dependencies: [
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client")
      ],
      resources: [
        .copy("openapi-generator-config.yaml"),
        .copy("openapi.yaml")
      ],
      plugins: [
        .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
      ]
    ),
    .testTarget(
      name: "NovitaTests",
      dependencies: ["Novita"],
      resources: [
        .copy("Ironman.png"),
        .copy("conan.png"),
        .copy("angelina.png")
      ]
    ),
  ]
)
