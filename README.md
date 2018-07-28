# SimpleController
----------------------------

[![https://travis-ci.org/m-hous/simplecontroller](https://img.shields.io/travis/m-housh/simplecontroller.svg)
[[![codecov](https://codecov.io/gh/m-housh/simplecontroller/branch/master/graph/badge.svg)](https://codecov.io/gh/m-housh/simplecontroller)

Allows for simple / quick `CRUD` controller's for `Vapor-3` database models.


## Usage
---------------

### Package.swift
```
    import PackageDescription

    let package = Package(
        name: "MyVaporApp"
        dependencies: [
             // 💧 A server-side Swift web framework.
            .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

            // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
            .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        
            // Simple controller
            .package(url: "https://github.com/m-housh/simplecontroller.git", from: "0.1.3") 
        ],
        targets: [
            .target(name: "App", dependencies: ["Vapor", "FluentSQLite",
            "SimpleController"]),
            ...
        ]
    )
```
