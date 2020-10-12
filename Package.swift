// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Rippl",
  platforms: [.iOS(.v8)],
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
