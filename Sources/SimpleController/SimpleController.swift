//
//  SimpleController.swift
//  App
//
//  Created by Michael Housh on 7/26/18.
//

import Vapor
import Fluent
//import FluentSQLite


public protocol ModelController {
    
    associatedtype DBModel: Model, Parameter
    
    func getHandler(_ request: Request) throws -> Future<[DBModel]>
    func getByIdHandler(_ request: Request) throws -> Future<DBModel>
    func createHandler(_ request: Request) throws -> Future<DBModel>
    func deleteHandler(_ request: Request) throws -> Future<HTTPResponseStatus>
    func updateHandler(_ request: Request) throws -> Future<DBModel>
    
}

extension ModelController {
    
    func getHandler(_ request: Request) throws -> Future<[DBModel]> {
        let limitCtx = try request.query.decode(LimitingContext.self)
        return DBModel.query(on: request)
            .limit(limitCtx)
            .all()
    }
    
    func getByIdHandler(_ request: Request) throws -> Future<DBModel> {
        return try request.parameters.next(DBModel.self) as! EventLoopFuture<DBModel>
    }
    
    func createHandler(_ request: Request) throws -> Future<DBModel> {
        return try request.content.decode(DBModel.self).flatMap { model in
            return model.save(on: request)
        }
    }
    
    
}

extension ModelController where DBModel.ResolvedParameter == Future<DBModel>{
    
    func deleteHandler(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try request.parameters.next(DBModel.self).flatMap { model in
            return model.delete(on: request)
            }.transform(to: .ok)
    }
    
    func updateHandler(_ request: Request) throws -> Future<DBModel> {
        return try request.content.decode(DBModel.self).flatMap { model in
            return model.update(on: request)
        }
    }
    
}
