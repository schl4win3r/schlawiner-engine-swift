@testable import SchlawinerEngine
import XCTest

final class AlgorithmTests: XCTestCase {
    
    func testOperationAlgorithm() throws {
        let solutions = OperationAlgorithm().compute(a: 2, b: 3, c: 5, target: 15)
        XCTAssertEqual(15, solutions.bestSolution().result)
        XCTAssertEqual("30 + 5 - 20 = 15", solutions.bestSolution().description)
    }
    
    func testTermAlgorithm() throws {
        let solutions = TermAlgorithm().compute(a: 2, b: 3, c: 5, target: 15)
        XCTAssertEqual(15, solutions.bestSolution().result)
        XCTAssertEqual("30 + 5 - 20 = 15", solutions.bestSolution().description)
    }
    
    func testAlgorithmComparison() throws {
        let diceNumbers: [[Int]] = [
            [2, 3, 5],
            [3, 6, 6],
            [4, 4, 4]
        ]
        
        let operationResults = computeAlgorithm(algorithm: OperationAlgorithm())
        let termResults = computeAlgorithm(algorithm: TermAlgorithm())
        for (index, _) in diceNumbers.enumerated() {
            XCTAssertEqual(operationResults[index].bestSolution(), termResults[index].bestSolution())
        }
        
        func computeAlgorithm(algorithm: Algorithm) -> [Solutions] {
            var results: [Solutions] = []
            for dn in diceNumbers {
                let clock = SuspendingClock()
                let duration = clock.measure {
                    for target in 1...100 {
                        results.append(algorithm.compute(a: dn[0], b: dn[1], c: dn[2], target: target))
                    }
                }
                print("""
                    \(algorithm.description) finished in \(duration.formatted(.units(allowed: [.seconds, .milliseconds], width: .wide)))
                    for targets 1..100 using [\(dn[0]),\(dn[1]),\(dn[2])]
                    """)
            }
            return results
        }
    }
    
    // Skipped - to enable remove the underscroe
    func _testFindDifference() throws {
        let diceNumberCombinations: [[Int]] = [
            [1, 1, 1],
            [1, 1, 2], [1, 1, 3], [1, 1, 4], [1, 1, 5],
            [1, 1, 6],
            [1, 2, 2], [1, 2, 3], [1, 2, 4], [1, 2, 5], [1, 2, 6],
            [1, 3, 3], [1, 3, 4], [1, 3, 5], [1, 3, 6],
            [1, 4, 4], [1, 4, 5], [1, 4, 6],
            [1, 5, 5], [1, 5, 6],
            [1, 6, 6],
            [2, 2, 2], [2, 2, 3], [2, 2, 4], [2, 2, 5], [2, 2, 6],
            [2, 3, 3], [2, 3, 4], [2, 3, 5], [2, 3, 6],
            [2, 4, 4], [2, 4, 5], [2, 4, 6],
            [2, 5, 5], [2, 5, 6],
            [2, 6, 6],
            [3, 3, 3], [3, 3, 4], [3, 3, 5], [3, 3, 6],
            [3, 4, 4], [3, 4, 5], [3, 4, 6],
            [3, 5, 5], [3, 5, 6],
            [3, 6, 6],
            [4, 4, 4], [4, 4, 5], [4, 4, 6],
            [4, 5, 5], [4, 5, 6],
            [4, 6, 6],
            [5, 5, 5], [5, 5, 6], [5, 6, 6],
            [6, 6, 6],
        ]
        
        var allowedDifference = 0
        while (true) {
            var solutionForAnyCombination = true
            print("Checking \(allowedDifference)")
            let algorithm: Algorithm = OperationAlgorithm(allowedDifference: allowedDifference)
            mainLoop: for target in 1...100 {
                for dnc in diceNumberCombinations {
                    let solutions = algorithm.compute(a: dnc[0], b: dnc[1], c: dnc[2], target: target)
                    if (solutions.bestSolution() == MAX_SOLUTION) {
                        solutionForAnyCombination = false
                        break mainLoop
                    }
                }
            }
            if (solutionForAnyCombination) {
                print("\nMax difference: \(allowedDifference)")
                break
            }
            allowedDifference += 1
        }
    }
}
