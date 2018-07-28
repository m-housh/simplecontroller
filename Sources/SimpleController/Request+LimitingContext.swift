//
//  Request+LimitingContext.swift
//  SimpleController
//
//  Created by Michael Housh on 7/27/18.
//

import Vapor


extension Request {
    
    /// Decodes and returns the `LimitingContext` for a `Request`.
    public func limitingContext() throws -> LimitingContext {
        return try self.query.decode(LimitingContext.self)
    }
}
