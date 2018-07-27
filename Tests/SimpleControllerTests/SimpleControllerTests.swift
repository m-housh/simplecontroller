import XCTest
@testable import SimpleController

final class SimpleControllerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SimpleController().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
