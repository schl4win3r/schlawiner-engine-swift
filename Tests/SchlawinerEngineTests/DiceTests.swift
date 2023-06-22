@testable import SchlawinerEngine
import XCTest

final class DiceTests: XCTestCase {
    var dice: Dice!
    
    override func setUpWithError() throws {
        dice = Dice(a: 1, b: 2, c: 3)
    }
    
    func testTwoNumbers() throws {
        do {
            try dice.validate(term: "1 + 2".toTerm())
            XCTFail("DiceError expected")
        } catch DiceError.lessNumbers {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testFourNumbers() throws {
        do {
            try dice.validate(term: "1 + 2 + 3 + 4".toTerm())
            XCTFail("DiceError expected")
        } catch DiceError.moreNumbers {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testWrongNumbers() throws {
        do {
            try dice.validate(term: "1 + 2 + 4".toTerm())
            XCTFail("DiceError expected")
        } catch DiceError.unusedNumbers {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testWrongMultiplier() throws {
        do {
            try dice.validate(term: "1 + 2 + 3000".toTerm())
            XCTFail("DiceError expected")
        } catch DiceError.unusedNumbers {
            return
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testValidate() throws {
        try dice.validate(term: "1 + 2 + 3".toTerm())
        try dice.validate(term: "1 + 20 + 300".toTerm())
    }
    
    func testUsed() {
        XCTAssertEqual([false, false, false], try dice.used(expression: ""))
        XCTAssertEqual([false, false, false], try dice.used(expression: "   "))

        XCTAssertEqual([true, false, false], try dice.used(expression: "1"))
        XCTAssertEqual([false, true, false], try dice.used(expression: "2"))
        XCTAssertEqual([false, false, true], try dice.used(expression: "3"))

        XCTAssertEqual([true, false, false], try dice.used(expression: "4 1"))
        XCTAssertEqual([false, true, false], try dice.used(expression: "5 2"))
        XCTAssertEqual([false, false, true], try dice.used(expression: "6 3"))

        XCTAssertEqual([true, false, false], try dice.used(expression: "1 4"))
        XCTAssertEqual([false, true, false], try dice.used(expression: "2 5"))
        XCTAssertEqual([false, false, true], try dice.used(expression: "3 6"))

        XCTAssertEqual([true, false, false], try dice.used(expression: "4 1 4"))
        XCTAssertEqual([false, true, false], try dice.used(expression: "5 2 5"))
        XCTAssertEqual([false, false, true], try dice.used(expression: "6 3 6"))

        XCTAssertEqual([true, false, false], try dice.used(expression: "10"))
        XCTAssertEqual([true, false, false], try dice.used(expression: "100"))
        XCTAssertEqual([true, false, false], try dice.used(expression: "1 10 100"))
        XCTAssertEqual([true, false, false], try dice.used(expression: "4 5 100"))
    }
}
