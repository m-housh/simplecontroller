//
//  QueryBuilder+LimitingContext.swift
//  SimpleController
//
//  Created by Michael Housh on 7/27/18.
//

import Fluent

/// Add's the `limit` method to `QueryBuilder`,
/// this allows for the any query to use the `LimitingContext`
///
/// Example:
/// `Foo.query(on: request).limit(try request.limitingContext()).all()`
extension QueryBuilder {
    
    // TODO: This should be cleaned up
    /// Limit's the query, if applicable.
    public func limit(_ ctx: LimitingContext) -> Self {
        var start: Int = 0
        var end: Int? = ctx.limit
        
        if let startIndex = ctx.startIndex, startIndex > 0 {
            start = startIndex
            if let ctxEnd = ctx.endIndex {
                return range(start...ctxEnd)
            }
            else if end != nil {
                end = end! + start
            }
        }
        
        guard let strongEnd = end else {
            return self
        }

        return range(start..<strongEnd)
    }
}
