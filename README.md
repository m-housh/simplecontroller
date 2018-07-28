# SimpleController
----------------------------

![https://travis-ci.org/m-hous/simplecontroller](https://img.shields.io/travis/m-housh/simplecontroller.svg)
![codecov](https://codecov.io/gh/m-housh/simplecontroller/branch/master/graph/badge.svg)](https://codecov.io/gh/m-housh/simplecontroller)

Allows for simple / quick `CRUD` controller's for `Vapor-3` database models.
This can be used to quickly proto-type or if you have some models that just need
basic CRUD operations.


## Usage

### Package.swift

Add the `SimpleController` package to your `Vapor3` project.

``` swift
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

### Foo.swift
Create a model that we can use for our controller.

``` swift

    import Vapor
    import FluentSQLite

    /// An example model.
    public final class Foo: SQLiteModel, Migration, Content, Parameter {
    
        /// The unique identifier for `Foo`.
        public var id: Int?
    
        /// The bar string for `Foo`.
        public var bar: String
    
        init(id: Int? = nil, bar: String) {
            self.id = id
            self.bar = bar
        }
    }
```

### FooController.swift
Create a controller for our model.

``` swift
    
    import Vapor
    import FluentSQLite
    import SimpleController

    /// An example controller.
    ///
    /// The `ModelController` protocol has default handlers
    /// for quick - simple routes.
    ///
    public final class FooController: ModelController {
        public typealias DBModel = Foo
        public let path = "foo"
    }

    /// Conform our controller to `RouteCollection`.
    extension FooController: RouteCollection {
    
        /// Create our CRUD routes for "/foo" end-point.
        public func boot(router: Router) throws {
            router.get(path, use: getHandler)
            router.get(path, Foo.parameter, use: getByIdHandler)
            router.post(path, use: createHandler)
            router.put(path, Foo.parameter, use: updateHandler)
            router.delete(path, Foo.parameter, use: deleteHandler)

            /// Add more addvanced / custom routes if needed
        }
    
    }

```

### routes.swift
Register your routes.
``` swift

    import Vapor

    public func routes(_ router: Router) throws {
        
        // Basic "Hello, world!" example
        router.get("hello") { req in 
            return "Hello, world!"
        }

        // Create a `FooController` to register with our router.
        let fooController = FooController()
        router.register(collection: fooController)
    }
```

The application will now have simple CRUD routes for the `Foo` model.  The `GET`
path also has functionality to limit the results.  This can be done in different
ways depending on the query parameters.

#### Example:

These examples require you to have some models saved in the database.

- Get the first 10 `Foo`'s `http://localhost:8080/foo?limit=10`
- Get `Foo`'s 2 and 3: `http://localhost:8080/foo?startIndex=1&limit=2`
- Same as above but with endIndex:
  `http://localhost:8080/foo?startIndex=1&endIndex=3`

##### Note:

    Index's are 0 based.

