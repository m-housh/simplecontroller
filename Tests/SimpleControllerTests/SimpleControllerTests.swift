import XCTest
import Vapor
@testable import SimpleController



final class SimpleControllerTests: VaporTestCase {
    
    let fooURI = "/foo"
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssert(true)
    }
    
    func testGet() {
        perform {
            let foo = Foo(bar: "baz")
            _ = foo.save(on: conn)
        
            let response = try app.getResponse(to: fooURI, decodeTo: [Foo].self)
            XCTAssertTrue(response.count == 1)
        }
    }
    
    func testPost() {
        perform {
            let foo = Foo(bar: "bing")
            let responseFoo = try app.getResponse(to: fooURI, method: .POST, data: foo, decodeTo: Foo.self)
            XCTAssertTrue(responseFoo.bar == "bing")
        }
    }
    
    func testGetOne() {
        perform {
            let foo = Foo(bar: "bam")
            let saved = try foo.save(on: conn).wait()
            
            let response = try app.getResponse(to: "\(fooURI)/\(saved.id!)", decodeTo: Foo.self)
            XCTAssert(response.bar == "bam")
        }
    }
    
    func testPut() {
        perform {
            let foo = Foo(bar: "boom")
            let saved = try foo.save(on: conn).wait()
            
            saved.bar = "updated"
            
            let response = try app.getResponse(to: "\(fooURI)/\(saved.id!)", method: .PUT, data: saved, decodeTo: Foo.self)
            XCTAssert(response.bar == "updated")
            XCTAssertTrue(response.id! == saved.id!)
        }
    }
    
    func testDelete() {
        perform {
            let foo = Foo(bar: "bang")
            let saved = try foo.save(on: conn).wait()
            
            var foos = try app.getResponse(to: fooURI, method: .GET, decodeTo: [Foo].self)
            XCTAssertEqual(foos.count, 1)
            
            _ = try app.sendRequest(to: "\(fooURI)/\(saved.id!)", method: .DELETE)
            foos = try app.getResponse(to: fooURI, method: .GET, decodeTo: [Foo].self)
            XCTAssertEqual(foos.count, 0)
        }
    }
    
    func testLimit() {
        perform {
            // save some models to the db.
            for i in 0...5 {
                let foo = Foo(bar: "bar-\(i)")
                _ = try foo.save(on: conn).wait()
            }
            
            // test limiting the results.
            var foos = try app.getResponse(to: "\(fooURI)?limit=1", decodeTo: [Foo].self)
            XCTAssertEqual(foos.count, 1)
            
            // test using limiting results by index
            foos = try app.getResponse(to: "\(fooURI)?startIndex=2&endIndex=4", decodeTo: [Foo].self)
            XCTAssertEqual(foos.count, 3)
            XCTAssertEqual(foos[0].bar, "bar-2")
            XCTAssertEqual(foos[1].bar, "bar-3")
            XCTAssertEqual(foos[2].bar, "bar-4")
            
            // test limiting results with start index and a limit
            foos = try app.getResponse(to: "\(fooURI)?startIndex=1&limit=2", decodeTo: [Foo].self)
            XCTAssertEqual(foos.count, 2)
            XCTAssertEqual(foos[0].bar, "bar-1")
            XCTAssertEqual(foos[1].bar, "bar-2")
            
            /// test start index must be above 0.
            foos = try app.getResponse(to: "\(fooURI)?startIndex=-1", decodeTo: [Foo].self)
            XCTAssertEqual(foos.count, 6)
            
            /// test limit still works with start index of less than 0
            foos = try app.getResponse(to: "\(fooURI)?startIndex=-1&limit=1", decodeTo: [Foo].self)
            XCTAssertEqual(foos.count, 1)
        }
    }


    static var allTests = [
        ("testExample", testExample),
        ("testGet", testGet),
        ("testPost", testPost),
        ("testGetOne", testGetOne),
        ("testPut", testPut),
        ("testDelete", testDelete),
        ("testLimit", testLimit)
    ]
}
