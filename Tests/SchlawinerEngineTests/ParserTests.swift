@testable import SchlawinerEngine
import XCTest

let permutations: [[String]] = [
    ["a + b + c", "a b + c +"],
    ["a - b - c", "a b - c -"],
    ["a * b * c", "a b * c *"],
    ["a / b / c", "a b / c /"],
    ["a + b - c", "a b + c -"],
    ["a * b / c", "a b * c /"],
    ["a * b + c", "a b * c +"],
    ["(a + b) * c", "a b + c *"],
    ["a * b - c", "a b * c -"],
    ["a - b * c", "a b c * -"],
    ["(a - b) * c", "a b - c *"],
    ["a / b + c", "a b / c +"],
    ["(a + b) / c", "a b + c /"],
    ["a / (b + c)", "a b c + /"],
    ["a / b - c", "a b / c -"],
    ["a - b / c", "a b c / -"],
    ["(a - b) / c", "a b - c /"],
    ["a / (b - c)", "a b c - /"],
]

final class ParserTests: XCTestCase {

    func testEmpty() throws {
        XCTAssert(try infixToRpn(expression: "").isEmpty)
    }

    func testBlank() throws {
        XCTAssert(try infixToRpn(expression: "   ").isEmpty)
    }
    
    func testPermutations() {
        for p in permutations {
            XCTAssertEqual(p[1], try infixToRpn(expression: p[0]).joined(separator: " "))
        }
    }
}
