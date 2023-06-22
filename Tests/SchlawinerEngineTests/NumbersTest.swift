@testable import SchlawinerEngine
import XCTest

final class NumbersTest: XCTestCase {

    func testNext() throws {
        let numbers = Numbers(numbers: [1, 2, 3, 4, 5])
        XCTAssertEqual(1, numbers.current)

        // round 1
        XCTAssertEqual(2, numbers.next())
        XCTAssertEqual(2, numbers.current)
        XCTAssertEqual(true, numbers.hasNext())

        // round 2
        XCTAssertEqual(3, numbers.next())
        XCTAssertEqual(3, numbers.current)
        XCTAssertEqual(true, numbers.hasNext())

        // round 3
        XCTAssertEqual(4, numbers.next())
        XCTAssertEqual(4, numbers.current)
        XCTAssertEqual(true, numbers.hasNext())

        // round 4
        XCTAssertEqual(5, numbers.next())
        XCTAssertEqual(5, numbers.current)
        XCTAssertEqual(false, numbers.hasNext())

        // end
        XCTAssertEqual(5, numbers.next())
        XCTAssertEqual(5, numbers.current)
        XCTAssertEqual(false, numbers.hasNext())
    }
}
