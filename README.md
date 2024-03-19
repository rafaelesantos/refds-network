# Refds Network

Refds Network is a Swift Package Manager library that provides a simple and elegant way to perform HTTP and WebSocket requests in Swift applications, inspired by libraries like Alamofire.

## Features

- [x] HTTP requests: GET, POST, PUT, DELETE, etc.
- [x] Support for custom headers.
- [x] Support for query parameters.
- [x] WebSocket requests for real-time communication.
- [x] Easy JSON handling with Codable.
- [x] Asynchronous operations and callbacks for response handling.
- [x] Compatible with iOS, macOS, tvOS, and watchOS.

## Installation

Add this project to your `Package.swift` file.

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://github.com/rafaelesantos/refds-network.git", branch: "main")
    ],
    targets: [
        .target(
            name: "YourProject",
            dependencies: [
                .product(
                    name: "RefdsNetwork",
                    package: "refds-network"),
            ]),
    ]
)
```
