//
//  FooModel.swift
//  SimpleControllerTests
//
//  Created by Michael Housh on 7/27/18.
//

import Vapor
import FluentSQLite
import SimpleController

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

public final class PublicFoo: PublicConvertible, Content {
    public typealias DBModel = Foo
    
    public var bar: String
    
    init(bar: String) {
        self.bar = bar
    }
    
    public static func convert(_ model: Foo) throws -> Codable {
        return PublicFoo(bar: model.bar)
    }
}
