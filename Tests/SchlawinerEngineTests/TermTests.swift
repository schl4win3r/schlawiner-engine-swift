@testable import SchlawinerEngine
import XCTest

final class TermTests: XCTestCase {
    
    func testEmpty() throws {
        do {
            let _ = try "".toTerm()
            XCTFail("TermError expected")
        } catch TermError.invalid(expression: _) {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testBlank() throws {
        do {
            let _ = try "   ".toTerm()
            XCTFail("TermError expected")
        } catch TermError.invalid(expression: _) {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testInvalid() throws {
        do {
            let _ = try "foo".toTerm()
            XCTFail("TermError expected")
        } catch TermError.invalid(expression: _) {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testOneNumber() throws {
        do {
            let _ = try "1".toTerm()
            XCTFail("TermError expected")
        } catch TermError.invalid(expression: _) {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testOneOperatore() throws {
        do {
            let _ = try "+".toTerm()
            XCTFail("TermError expected")
        } catch TermError.invalid(expression: _) {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testNoOperator() throws {
        do {
            let _ = try "1 2".toTerm()
            XCTFail("TermError expected")
        } catch TermError.invalid(expression: _) {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testWrongOperator() throws {
        do {
            let _ = try "10 & 2 % 3".toTerm()
            XCTFail("TermError expected")
        } catch TermError.invalid(expression: _) {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testEval() throws {
        XCTAssertEqual(10, try "2 + 3 + 5".toTerm().eval(assignments: []))
        XCTAssertEqual(11, try "2 * 3 + 5".toTerm().eval(assignments: []))
        XCTAssertEqual(16, try "2 * (3 + 5)".toTerm().eval(assignments: []))
        XCTAssertEqual(25, try "(2 + 3) * 5".toTerm().eval(assignments: []))
        XCTAssertEqual(12, try "10 * (3 - 2) + (4 + 6) / n".toTerm().eval(assignments: [Assignment(name: "n", value: 5)]))
        XCTAssertEqual(16, try "10+2*3".toTerm().eval(assignments: []))
        XCTAssertEqual(36, try "(10+2)*3".toTerm().eval(assignments: []))
        XCTAssertEqual(16, try "10 + 2 * 3".toTerm().eval(assignments: []))
        XCTAssertEqual(36, try "(10 + 2) * 3".toTerm().eval(assignments: []))
        XCTAssertEqual(36, try "((10 + 2) * (3))".toTerm().eval(assignments: []))
    }
    
    func testPrint() {
        XCTAssertEqual("2 + 3 + 5", try "2 + 3 + 5".toTerm().print(assignments: []))
        XCTAssertEqual("2 * 3 + 5", try "2 * 3 + 5".toTerm().print(assignments: []))
        XCTAssertEqual("2 * (3 + 5)", try "2 * (3 + 5)".toTerm().print(assignments: []))
        XCTAssertEqual("(2 + 3) * 5", try "(2 + 3) * 5".toTerm().print(assignments: []))
        XCTAssertEqual("10 * (3 - 2) + (4 + 6) / n", try "10 * (3 - 2) + (4 + 6) / n".toTerm().print(assignments: []))
        XCTAssertEqual("10 + 2 * 3", try "10+2*3".toTerm().print(assignments: []))
        XCTAssertEqual("(10 + 2) * 3", try "(10+2)*3".toTerm().print(assignments: []))
        XCTAssertEqual("10 + 2 * 3", try "10 + 2 * 3".toTerm().print(assignments: []))
        XCTAssertEqual("(10 + 2) * 3", try "(10 + 2) * 3".toTerm().print(assignments: []))
        XCTAssertEqual("(10 + 2) * 3", try "((10 + 2) * (3))".toTerm().print(assignments: []))
    }
    
    func testValues() {
        XCTAssertEqual([2, 3, 5], try "2 + 3 + 5".toTerm().values)
        XCTAssertEqual([2, 3, 5], try "2 * 3 + 5".toTerm().values)
        XCTAssertEqual([2, 3, 5], try "2 * (3 + 5)".toTerm().values)
        XCTAssertEqual([2, 3, 5], try "(2 + 3) * 5".toTerm().values)
        XCTAssertEqual([10, 3, 2, 4, 6], try "10 * (3 - 2) + (4 + 6) / n".toTerm().values)
        XCTAssertEqual([10, 2, 3], try "10+2*3".toTerm().values)
        XCTAssertEqual([10, 2, 3], try "(10+2)*3".toTerm().values)
        XCTAssertEqual([10, 2, 3], try "10 + 2 * 3".toTerm().values)
        XCTAssertEqual([10, 2, 3], try "(10 + 2) * 3".toTerm().values)
        XCTAssertEqual([10, 2, 3], try "((10 + 2) * (3))".toTerm().values)
    }
}
