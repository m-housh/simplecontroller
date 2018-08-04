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
