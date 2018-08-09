//
//  ModelController2.swift
//  Async
//
//  Created by Michael Housh on 8/4/18.
//

import Vapor
import Fluent


public final class ModelRouteCollection<M>: ModelControllable where M: Model & Parameter & Content, M.ResolvedParameter == Future<M> {
    
    public typealias DBModel = M
    
    public let Model: M.Type
    public let path: [PathComponentsRepresentable]
    public let middleware: [Middleware]?
    
    public init(_ type: M.Type, path: PathComponentsRepresentable...,
                using middleware: [Middleware]? = nil) {
        self.Model = type
        self.path = path
        self.middleware = middleware
    }
    
    public init(_ type: M.Type, path: [PathComponentsRepresentable],
                using middleware: [Middleware]? = nil) {
        self.Model = type
        self.path = path
        self.middleware = middleware
    }
    
    /// See `RouteCollection`.
    public func boot(router: Router) throws {
        var group = router
        if let middleware = middleware {
            group = router.grouped(middleware)
        }
        
        group.get(path, use: getHandler)
        group.get(path, Model.parameter, use: getByIdHandler)
        group.post(path, use: createHandler)
        group.put(path, Model.parameter, use: updateHandler)
        group.delete(path, Model.parameter, use: deleteHandler)
    }
}

