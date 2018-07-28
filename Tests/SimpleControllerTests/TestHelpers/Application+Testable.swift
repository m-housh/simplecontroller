//
//  Application+Testable.swift
//  SimpleControllerTests
//
//  Created by Michael Housh on 7/27/18.
//
// Credit for primarily adapting setup from: https://github.com/raywenderlich/vapor-til

import Vapor
import FluentSQLite

extension Application {
    
    static func testable(_ envArgs: [String]? = nil) throws -> Application {
        // config, env, services for our applicaation
        // setup in this method
        let config = Config.default()
        var env = Environment.testing
        var services = Services.default()
        
        if let environmentArgs = envArgs {
            env.arguments = environmentArgs
        }
        
        // register provider's first
        try services.register(FluentSQLiteProvider())
        
        // setup our router for our test routes
        let router = EngineRouter.default()
        let fooController = FooController()
        try router.register(collection: fooController)
        services.register(router, as: Router.self)
        
        // Configure a SQLite database
        let sqlite = try SQLiteDatabase(storage: .memory)
        
        /// Register the configured SQLite database to the database config.
        var databases = DatabasesConfig()
        databases.add(database: sqlite, as: .sqlite)
        services.register(databases)
        
        /// Configure migrations
        var migrations = MigrationConfig()
        migrations.add(model: Foo.self, database: .sqlite)
        services.register(migrations)
        
        var commandConfig = CommandConfig.default()
        commandConfig.useFluentCommands()
        services.register(commandConfig)
        
        return try Application(config: config, environment: env, services: services)
    }
    
    static func reset() throws {
        let resetArgs = ["vapor", "revert",  "--all", "-y"]
        try Application.testable(resetArgs).asyncRun().wait()
        let migrateEnvironment = ["vapor", "migrate", "-y"]
        try Application.testable(migrateEnvironment).asyncRun().wait()
    }
    
    func sendRequest<T>(to path: String, method: HTTPMethod, headers: HTTPHeaders = .init(), body: T? = nil) throws -> Response where T: Content {
        var headers = headers
        
        if !headers.contains(name: .contentType) {
            headers.add(name: .contentType, value: "application/json")
        }
        
        let responder = try self.make(Responder.self)
        let request = HTTPRequest(method: method, url: URL(string: path)!, headers: headers)
        let wrappedRequest = Request(http: request, using: self)
        if let body = body {
            try wrappedRequest.content.encode(body)
        }
        return try responder.respond(to: wrappedRequest).wait()
    }
    
    func getResponse<C, T>(to path: String, method: HTTPMethod = .GET, headers: HTTPHeaders = .init(), data: C? = nil, decodeTo type: T.Type) throws -> T where C: Content, T: Decodable {
        let response = try self.sendRequest(to: path, method: method, headers: headers, body: data)
        return try response.content.decode(type).wait()
    }
    
    func getResponse<T>(to path: String, method: HTTPMethod = .GET, headers: HTTPHeaders = .init(), decodeTo type: T.Type) throws -> T where T: Content {
        let emptyContent: EmptyContent? = nil
        return try self.getResponse(to: path, method: method, headers: headers, data: emptyContent, decodeTo: type)
    }
    
    func sendRequest<T>(to path: String, method: HTTPMethod, headers: HTTPHeaders, data: T) throws where T: Content {
        _ = try self.sendRequest(to: path, method: method, headers: headers, body: data)
    }
    
    func sendRequest(to path: String, method: HTTPMethod, headers: HTTPHeaders = .init()) throws -> Response {
        let emptyContent: EmptyContent? = nil
        return try sendRequest(to: path, method: method, headers: headers, body: emptyContent)
    }
}

struct EmptyContent: Content {}
