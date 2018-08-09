//
//  PublicConvertible.swift
//  SimpleController
//
//  Created by Michael Housh on 8/8/18.
//

import Vapor
import Fluent


public protocol PublicConvertible: Content {
    associatedtype DBModel: Model
    static func convert(_ model: DBModel) throws -> Codable
}
