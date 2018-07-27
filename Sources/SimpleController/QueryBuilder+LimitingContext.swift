//
//  QueryBuilder+LimitingContext.swift
//  SimpleController
//
//  Created by Michael Housh on 7/27/18.
//

import Fluent

extension QueryBuilder {
    
    public func limit(_ ctx: LimitingContext) -> Self {
        var start: Int = 0
        var end: Int? = nil
        
        if let limit = ctx.limit {
            end = limit
        }
        
        if let startIndex = ctx.startIndex {
            start = startIndex
            if let strongEnd = end {
                end = strongEnd + start
            }
        }
        
        if let endIndex = ctx.endIndex {
            end = endIndex
        }
        
        guard let strongEnd = end else {
            return self
        }
        return range(start..<strongEnd)
    }
}
