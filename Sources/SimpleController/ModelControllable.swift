//
//  SimpleController.swift
//  App
//
//  Created by Michael Housh on 7/26/18.
//

import Vapor
import Fluent


/// A simple database model controller.
/// This model add's CRUD route handler's to a class, that can easily
/// be used as to register routes or make a `RouteController`.
public protocol ModelControllable {
    
    /// The database `Model` that this controller is for.
    /// The `DBModel` should conform to the `Model` and `Parameter` protocols
    associatedtype DBModel: Model, Parameter
    
    
    /// The handler used for a `GET` request.
    /// The default implementations also allows limiting the results
    /// based on query parameters.
    ///
    /// For example:
    ///     (limit): `http://example.com/foo?limit=50`
    ///     (start / end): `http://example.com/foo?startIndex=1&endIndex=10`
    ///     (start / limit): `http://example.com/foo?startIndex=10&limit=10`
    func getHandler(_ request: Request) throws -> Future<[DBModel]>
    
    /// The handler used to get a single `DBModel` by id.
    /// Example: 'http://example.com/foo/1'
    func getByIdHandler(_ request: Request) throws -> Future<DBModel>
    
    /// The handler used to `POST` a new `DBModel`.
    func createHandler(_ request: Request) throws -> Future<DBModel>
    
    /// The handler used to `DELETE` a `DBModel`
    func deleteHandler(_ request: Request) throws -> Future<HTTPResponseStatus>
    
    /// The handler used to `PUT` a `DBModel`.
    /// The default implementation requires the entire model to be
    /// in the request.  Override this method if you want a different behavior.
    func updateHandler(_ request: Request) throws -> Future<DBModel>
    
}

/*
extension ModelController {
    
    public func getHandler(_ request: Request) throws -> Future<[DBModel]> {
        return DBModel.query(on: request)
            .limit(try request.limitingContext())
            .all()
    }
    
    public func getByIdHandler(_ request: Request) throws -> Future<DBModel> {
        return try request.parameters.next(DBModel.self) as! EventLoopFuture<DBModel>
    }
    
    public func createHandler(_ request: Request) throws -> Future<DBModel> {
        return try request.content.decode(DBModel.self).flatMap { model in
            return model.save(on: request)
        }
    }
    
    
}

extension ModelController where DBModel.ResolvedParameter == Future<DBModel>{
    
    public func deleteHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(DBModel.self).flatMap { model in
            return model.delete(on: request)
            }.transform(to: .ok)
    }
    
    public func updateHandler(_ request: Request) throws -> Future<DBModel> {
        return try request.content.decode(DBModel.self).flatMap { model in
            return model.update(on: request)
        }
    }
    
}
*/
