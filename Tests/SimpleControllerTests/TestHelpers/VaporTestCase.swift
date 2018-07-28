//
//  TestCase.swift
//  SimpleControllerTests
//
//  Created by Michael Housh on 7/27/18.
//
// `perform` function credit from: https://github.com/gtranchedone/vapor-testing-template

import XCTest
import Vapor
import FluentSQLite

extension XCTestCase {
    
    func perform(_ closure: () throws -> ()) {
        do {
            try closure()
        } catch {
            XCTFail("\n\n😱 Error => \(error) 😱\n\n")
        }
    }
}

public class VaporTestCase: XCTestCase {
    
    public var app: Application!
    public var conn: SQLiteConnection!
    
    public override func setUp() {
        super.setUp()
        
        perform {
            try Application.reset()
            app = try! Application.testable()
            conn = try! app.newConnection(to: .sqlite).wait()
        }
    }
    
    public override func tearDown() {
        conn.close()
        super.tearDown()
    }
}


