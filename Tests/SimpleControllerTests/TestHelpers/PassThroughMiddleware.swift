//
//  PassThroughMiddleware.swift
//  SimpleControllerTests
//
//  Created by Michael Housh on 8/4/18.
//

import Vapor

struct PassThroughMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        return try next.respond(to: request)
    }
}
