//
//  LimitingContext.swift
//  SimpleController
//
//  Created by Michael Housh on 7/27/18.
//

import Vapor

struct LimitingContext: Content {
    
    let limit: Int?
    let startIndex: Int?
    let endIndex: Int?
    
}
