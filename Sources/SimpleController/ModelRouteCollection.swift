//
//  ModelController2.swift
//  Async
//
//  Created by Michael Housh on 8/4/18.
//

import Vapor
import Fluent


public class ModelRouteCollection<M> where M: Model & Parameter & Content, M.ResolvedParameter == Future<M> {
    
    public let Model: M.Type
    public let path: [PathComponentsRepresentable]
    public let middleware: [Middleware]?
    
    public init(_ type: M.Type, path: PathComponentsRepresentable..., using middleware: [Middleware]? = nil) {
        self.Model = type
        self.path = path
        self.middleware = middleware
    }
    
    public init(_ type: M.Type, path: [PathComponentsRepresentable], using middleware: [Middleware]? = nil) {
        self.Model = type
        self.path = path
        self.middleware = middleware
    }
    
}

extension ModelRouteCollection {
    
    public func getHandler(_ request: Request) throws -> Future<[M]> {
        return Model.query(on: request)
            .limit(try request.limitingContext())
            .all()
    }
    
   
    public func createHandler(_ request: Request) throws -> Future<M> {
        return try request.content.decode(Model.self).flatMap { model in
            return model.save(on: request)
        }
    }
    
}

extension ModelRouteCollection where M.ResolvedParameter == Future<M> {
    
    public func getByIdHandler(_ request: Request) throws -> Future<M> {
        return try request.parameters.next(Model.self)
    }
    
    public func deleteHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(Model.self).flatMap { model in
            return model.delete(on: request)
            }.transform(to: .ok)
    }
    
    public func updateHandler(_ request: Request) throws -> Future<M> {
        return try request.content.decode(Model.self).flatMap { model in
            return model.update(on: request)
        }
    }
    
}

extension ModelRouteCollection: ModelControllable { }

extension ModelRouteCollection: RouteCollection {

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
