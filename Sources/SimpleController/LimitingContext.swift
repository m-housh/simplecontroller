//
//  LimitingContext.swift
//  SimpleController
//
//  Created by Michael Housh on 7/27/18.
//

import Vapor

/// Represents the query parameters that can be used
/// to limit a request to the primary `GET` end-point.
public struct LimitingContext: Content {
    let limit: Int?
    let startIndex: Int?
    let endIndex: Int?
}
