//
//  FooController.swift
//  SimpleControllerTests
//
//  Created by Michael Housh on 7/27/18.
//

import Vapor
import FluentSQLite
@testable import SimpleController

/// An example controller.
public final class FooController: ModelController {
    public typealias DBModel = Foo
    public let path = "foo"
}

/// Conform our controller to `RouteCollection`.
extension FooController: RouteCollection {
    
    public func boot(router: Router) throws {
        router.get(path, use: getHandler)
        router.get(path, Foo.parameter, use: getByIdHandler)
        router.post(path, use: createHandler)
        router.put(path, Foo.parameter, use: updateHandler)
        router.delete(path, Foo.parameter, use: deleteHandler)
    }
    
}
