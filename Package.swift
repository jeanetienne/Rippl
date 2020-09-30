// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Rippl",
  platforms: [.iOS(.v10)],
  products: [
    .library(
      name: "Rippl",
      targets: ["Rippl"])
  ],
  targets: [
    .target(
      name: "Rippl",
      dependencies: [],
      exclude: ["Rippl-Demo", "gain.gif", "impact.gif"])
  ]
)
