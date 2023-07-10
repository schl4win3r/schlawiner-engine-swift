// Calculated by AlgorithmTests.testFindDifference()
public let defaultDifference = 15
let algorithmMultipliers: [[Int]] = [
    [1, 1, 1],
    [1, 1, 10], [1, 10, 1], [10, 1, 1],
    [1, 1, 100], [1, 100, 1], [100, 1, 1],
    [1, 10, 10], [10, 1, 10], [10, 10, 1],
    [10, 10, 10],
    [10, 10, 100], [10, 100, 10], [100, 10, 10],
    [1, 100, 100], [100, 1, 100], [100, 100, 1],
    [10, 100, 100], [100, 10, 100], [100, 100, 10],
    [100, 100, 100],
    [1, 10, 100], [1, 100, 10], [10, 1, 100],
    [10, 100, 1], [100, 1, 10], [100, 10, 1],
]

public protocol Algorithm: CustomStringConvertible {
    func compute(a: Int, b: Int, c: Int, target: Int) -> Solutions
}

public class BaseAlgorithm: Algorithm {

    private let allowedDifference: Int
    public var description: String
    
    init(allowedDifference: Int, name: String) {
        self.allowedDifference = allowedDifference
        self.description = name
    }
    
    public func compute(a: Int, b: Int, c: Int, target: Int) -> Solutions {
        var solutions = Solutions(target: target, allowedDifference: allowedDifference)
        for multiplier in algorithmMultipliers {
            let am = a * multiplier[0]
            let bm = b * multiplier[1]
            let cm = c * multiplier[2]
            computePermutation(a: am, b: bm, c: cm, target: target, solutions: &solutions)
        }
        return solutions
    }
    
    func computePermutation(a: Int, b: Int, c: Int, target: Int, solutions: inout Solutions) {
        fatalError("Not implemented! Needs to be implemented in concrete algorithms")
    }
    
    func differentDiceNumbers(a: Int, b: Int, c: Int) -> Bool { a != b || a != c }
}

public class OperationAlgorithm : BaseAlgorithm {
    public init(allowedDifference: Int = defaultDifference) {
        super.init(allowedDifference: allowedDifference, name: "Algorithm based on static operations")
    }
    
    override func computePermutation(a: Int, b: Int, c: Int, target: Int, solutions: inout Solutions) {
        // a + b + c
        solutions.add(solution: add(a: a, b: b, c: c))
        
        // a - b - c
        solutions.add(solution: subtract(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: subtract(a: b, b: a, c: c))
            solutions.add(solution: subtract(a: c, b: a, c: b))
        }
        
        // a * b * c
        solutions.add(solution: multiply(a: a, b: b, c: c))
        
        // a / b / c
        solutions.add(solution: divide(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: divide(a: b, b: a, c: c))
            solutions.add(solution: divide(a: c, b: a, c: b))
        }
        
        // a + b - c
        solutions.add(solution: addSubtract(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: addSubtract(a: a, b: c, c: b))
            solutions.add(solution: addSubtract(a: b, b: c, c: a))
        }
        
        // a * b / c
        solutions.add(solution: multiplyDivide(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: multiplyDivide(a: a, b: c, c: b))
            solutions.add(solution: multiplyDivide(a: b, b: c, c: a))
        }
        
        // a * b + c
        solutions.add(solution: multiplyAdd(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: multiplyAdd(a: a, b: c, c: b))
            solutions.add(solution: multiplyAdd(a: b, b: c, c: a))
        }
        
        // (a + b) * c
        solutions.add(solution: addMultiply(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: addMultiply(a: a, b: c, c: b))
            solutions.add(solution: addMultiply(a: b, b: c, c: a))
        }
        
        // a * b - c
        solutions.add(solution: multiplySubtract1(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: multiplySubtract1(a: a, b: c, c: b))
            solutions.add(solution: multiplySubtract1(a: b, b: c, c: a))
        }
        
        // a - b * c
        solutions.add(solution: multiplySubtract2(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: multiplySubtract2(a: b, b: a, c: c))
            solutions.add(solution: multiplySubtract2(a: c, b: a, c: b))
        }
        
        // (a - b) * c
        solutions.add(solution: subtractMultiply(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: subtractMultiply(a: b, b: a, c: c))
            solutions.add(solution: subtractMultiply(a: a, b: c, c: b))
            solutions.add(solution: subtractMultiply(a: c, b: a, c: b))
            solutions.add(solution: subtractMultiply(a: b, b: c, c: a))
            solutions.add(solution: subtractMultiply(a: c, b: b, c: a))
        }
        
        // a / b + c
        solutions.add(solution: divideAdd(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: divideAdd(a: b, b: a, c: c))
            solutions.add(solution: divideAdd(a: a, b: c, c: b))
            solutions.add(solution: divideAdd(a: c, b: a, c: b))
            solutions.add(solution: divideAdd(a: b, b: c, c: a))
            solutions.add(solution: divideAdd(a: c, b: b, c: a))
        }
        
        // (a + b) / c
        solutions.add(solution: addDivide1(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: addDivide1(a: a, b: c, c: b))
            solutions.add(solution: addDivide1(a: b, b: c, c: a))
        }
        
        // a / (b + c)
        solutions.add(solution: addDivide2(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: addDivide2(a: b, b: a, c: c))
            solutions.add(solution: addDivide2(a: c, b: a, c: b))
        }
        
        // a / b - c
        solutions.add(solution: divideSubtract1(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: divideSubtract1(a: a, b: c, c: b))
            solutions.add(solution: divideSubtract1(a: b, b: a, c: c))
            solutions.add(solution: divideSubtract1(a: b, b: c, c: a))
            solutions.add(solution: divideSubtract1(a: c, b: a, c: b))
            solutions.add(solution: divideSubtract1(a: c, b: b, c: a))
        }
        
        // a - b / c
        solutions.add(solution: divideSubtract2(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: divideSubtract2(a: a, b: c, c: b))
            solutions.add(solution: divideSubtract2(a: b, b: a, c: c))
            solutions.add(solution: divideSubtract2(a: b, b: c, c: a))
            solutions.add(solution: divideSubtract2(a: c, b: a, c: b))
            solutions.add(solution: divideSubtract2(a: c, b: b, c: a))
        }
        
        // (a - b) / c
        solutions.add(solution: subtractDivide1(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: subtractDivide1(a: a, b: c, c: b))
            solutions.add(solution: subtractDivide1(a: b, b: a, c: c))
            solutions.add(solution: subtractDivide1(a: b, b: c, c: a))
            solutions.add(solution: subtractDivide1(a: c, b: a, c: b))
            solutions.add(solution: subtractDivide1(a: c, b: b, c: a))
        }
        
        // a / (b - c)
        solutions.add(solution: subtractDivide2(a: a, b: b, c: c))
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            solutions.add(solution: subtractDivide2(a: a, b: c, c: b))
            solutions.add(solution: subtractDivide2(a: b, b: a, c: c))
            solutions.add(solution: subtractDivide2(a: b, b: c, c: a))
            solutions.add(solution: subtractDivide2(a: c, b: a, c: b))
            solutions.add(solution: subtractDivide2(a: c, b: b, c: a))
        }
    }
    
    func add(a: Int, b: Int, c: Int) -> Solution { Solution(term: "\(a) + \(b) + \(c)", result: a + b + c) }
    
    func addDivide1(a: Int, b: Int, c: Int) -> Solution {
        if (a + b) % c != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "(\(a) + \(b)) / \(c)", result: (a + b) / c)
        }
    }
    
    func addDivide2(a: Int, b: Int, c: Int) -> Solution {
        if a % (b + c) != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "\(a) / (\(b) + \(c))", result: a / (b + c))
        }
    }
    
    func addMultiply(a: Int, b: Int, c: Int) -> Solution { Solution(term: "(\(a) + \(b)) * \(c)", result: (a + b) * c) }
    
    func addSubtract(a: Int, b: Int, c: Int) -> Solution { Solution(term: "\(a) + \(b) - \(c)", result: a + b - c) }
    
    func divide(a: Int, b: Int, c: Int) -> Solution {
        if a % b != 0 || a / b % c != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "\(a) / \(b) / \(c)", result: a / b / c)
        }
    }
    
    func divideAdd(a: Int, b: Int, c: Int) -> Solution {
        if a % b != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "\(a) / \(b) + \(c)", result: a / b + c)
        }
    }
    
    func divideSubtract1(a: Int, b: Int, c: Int) -> Solution {
        if a % b != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "\(a) / \(b) - \(c)", result: a / b - c)
        }
    }
    
    func divideSubtract2(a: Int, b: Int, c: Int) -> Solution {
        if b % c != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "\(a) - \(b) / \(c)", result: a - b / c)
        }
    }
    
    func multiply(a: Int, b: Int, c: Int) -> Solution { Solution(term: "\(a) * \(b) * \(c)", result: a * b * c) }
    
    func multiplyAdd(a: Int, b: Int, c: Int) -> Solution { Solution(term: "\(a) * \(b) + \(c)", result: a * b + c) }
    
    func multiplyDivide(a: Int, b: Int, c: Int) -> Solution {
        if a * b % c != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "\(a) * \(b) / \(c)", result: a * b / c)
        }
    }
    
    func multiplySubtract1(a: Int, b: Int, c: Int) -> Solution { Solution(term: "\(a) * \(b) - \(c)", result: a * b - c) }
    
    func multiplySubtract2(a: Int, b: Int, c: Int) -> Solution { Solution(term: "\(a) - \(b) * \(c)", result: a - b * c) }
    
    func subtract(a: Int, b: Int, c: Int) -> Solution { Solution(term: "\(a) - \(b) - \(c)", result: a - b - c) }
    
    func subtractDivide1(a: Int, b: Int, c: Int) -> Solution {
        if (a - b) % c != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "(\(a) - \(b)) / \(c)", result: (a - b) / c)
        }
    }
    
    func subtractDivide2(a: Int, b: Int, c: Int) -> Solution {
        if b - c == 0 || a % (b - c) != 0 {
            return INVALID_SOLUTION
        } else {
            return Solution(term: "\(a) / (\(b) - \(c))", result: a / (b - c))
        }
    }
    
    func subtractMultiply(a: Int, b: Int, c: Int) -> Solution { Solution(term: "(\(a) - \(b)) * \(c)", result: (a - b) * c) }
}

public class TermAlgorithm : BaseAlgorithm {
    let addAbc: Term
    let subtractAbc: Term
    let subtractBac: Term
    let subtractCab: Term
    let multiplyAbc: Term
    let divideAbc: Term
    let divideBac: Term
    let divideCab: Term
    let addSubtractAbc: Term
    let addSubtractAcb: Term
    let addSubtractBca: Term
    let multiplyDivideAbc: Term
    let multiplyDivideAcb: Term
    let multiplyDivideBca: Term
    let multiplyAddAbc: Term
    let multiplyAddAcb: Term
    let multiplyAddBca: Term
    let addMultiplyAbc: Term
    let addMultiplyAcb: Term
    let addMultiplyBca: Term
    let multiplySubtract1Abc: Term
    let multiplySubtract1Acb: Term
    let multiplySubtract1Bca: Term
    let multiplySubtract2Abc: Term
    let multiplySubtract2Bac: Term
    let multiplySubtract2Cab: Term
    let subtractMultiplyAbc: Term
    let subtractMultiplyBac: Term
    let subtractMultiplyAcb: Term
    let subtractMultiplyCab: Term
    let subtractMultiplyBca: Term
    let subtractMultiplyCBA: Term
    let divideAdd_Abc: Term
    let divideAdd_Bac: Term
    let divideAdd_Acb: Term
    let divideAdd_Cab: Term
    let divideAdd_Bca: Term
    let divideAdd_CBA: Term
    let addDivide1Abc: Term
    let addDivide1Acb: Term
    let addDivide1Bca: Term
    let addDivide2Abc: Term
    let addDivide2Bac: Term
    let addDivide2Cab: Term
    let divideSubtract1Abc: Term
    let divideSubtract1Acb: Term
    let divideSubtract1Bac: Term
    let divideSubtract1Bca: Term
    let divideSubtract1Cab: Term
    let divideSubtract1CBA: Term
    let divideSubtract2Abc: Term
    let divideSubtract2Acb: Term
    let divideSubtract2Bac: Term
    let divideSubtract2Bca: Term
    let divideSubtract2Cab: Term
    let divideSubtract2CBA: Term
    let subtractDivide1Abc: Term
    let subtractDivide1Acb: Term
    let subtractDivide1Bac: Term
    let subtractDivide1Bca: Term
    let subtractDivide1Cab: Term
    let subtractDivide1CBA: Term
    let subtractDivide2Abc: Term
    let subtractDivide2Acb: Term
    let subtractDivide2Bac: Term
    let subtractDivide2Bca: Term
    let subtractDivide2Cab: Term
    let subtractDivide2CBA: Term
    
    let abc: [Term]
    let permutations: [Term]
    
    public init(allowedDifference: Int = defaultDifference) {
        // a + b + c
        addAbc = try! "a + b + c".toTerm()
        
        // a - b - c
        subtractAbc = try! "a - b - c".toTerm()
        subtractBac = try! "b - a - c".toTerm()
        subtractCab = try! "c - a - b".toTerm()
        
        // a * b * c
        multiplyAbc = try! "a * b * c".toTerm()
        
        // a / b / c
        divideAbc = try! "a / b / c".toTerm()
        divideBac = try! "b / a / c".toTerm()
        divideCab = try! "c / a / b".toTerm()
        
        // a + b - c
        addSubtractAbc = try! "a + b - c".toTerm()
        addSubtractAcb = try! "a + c - b".toTerm()
        addSubtractBca = try! "b + c - a".toTerm()
        
        // a * b / c
        multiplyDivideAbc = try! "a * b / c".toTerm()
        multiplyDivideAcb = try! "a * c / b".toTerm()
        multiplyDivideBca = try! "b * c / a".toTerm()
        
        // a * b + c
        multiplyAddAbc = try! "a * b + c".toTerm()
        multiplyAddAcb = try! "a * c + b".toTerm()
        multiplyAddBca = try! "b * c + a".toTerm()
        
        // (a + b) * c
        addMultiplyAbc = try! "(a + b) * c".toTerm()
        addMultiplyAcb = try! "(a + c) * b".toTerm()
        addMultiplyBca = try! "(b + c) * a".toTerm()
        
        // a * b - c
        multiplySubtract1Abc = try! "a * b - c".toTerm()
        multiplySubtract1Acb = try! "a * c - b".toTerm()
        multiplySubtract1Bca = try! "b * c - a".toTerm()
        
        // a - b * c
        multiplySubtract2Abc = try! "a - b * c".toTerm()
        multiplySubtract2Bac = try! "b - a * c".toTerm()
        multiplySubtract2Cab = try! "c - a * b".toTerm()
        
        // (a - b) * c
        subtractMultiplyAbc = try! "(a - b) * c".toTerm()
        subtractMultiplyBac = try! "(b - a) * c".toTerm()
        subtractMultiplyAcb = try! "(a - c) * b".toTerm()
        subtractMultiplyCab = try! "(c - a) * b".toTerm()
        subtractMultiplyBca = try! "(b - c) * a".toTerm()
        subtractMultiplyCBA = try! "(c - b) * a".toTerm()
        
        // a / b + c
        divideAdd_Abc = try! "a / b + c".toTerm()
        divideAdd_Bac = try! "b / a + c".toTerm()
        divideAdd_Acb = try! "a / c + b".toTerm()
        divideAdd_Cab = try! "c / a + b".toTerm()
        divideAdd_Bca = try! "b / c + a".toTerm()
        divideAdd_CBA = try! "c / b + a".toTerm()
        
        // (a + b) / c
        addDivide1Abc = try! "(a + b) / c".toTerm()
        addDivide1Acb = try! "(a + c) / b".toTerm()
        addDivide1Bca = try! "(b + c) / a".toTerm()
        
        // a / (b + c)
        addDivide2Abc = try! "a / (b + c)".toTerm()
        addDivide2Bac = try! "b / (a + c)".toTerm()
        addDivide2Cab = try! "c / (a + b)".toTerm()
        
        // a / b - c
        divideSubtract1Abc = try! "a / b - c".toTerm()
        divideSubtract1Acb = try! "a / c - b".toTerm()
        divideSubtract1Bac = try! "b / a - c".toTerm()
        divideSubtract1Bca = try! "b / c - a".toTerm()
        divideSubtract1Cab = try! "c / a - b".toTerm()
        divideSubtract1CBA = try! "c / b - a".toTerm()
        
        // a - b / c
        divideSubtract2Abc = try! "a - b / c".toTerm()
        divideSubtract2Acb = try! "a - c / b".toTerm()
        divideSubtract2Bac = try! "b - a / c".toTerm()
        divideSubtract2Bca = try! "b - c / a".toTerm()
        divideSubtract2Cab = try! "c - a / b".toTerm()
        divideSubtract2CBA = try! "c - b / a".toTerm()
        
        // (a - b) / c
        subtractDivide1Abc = try! "(a - b) / c".toTerm()
        subtractDivide1Acb = try! "(a - c) / b".toTerm()
        subtractDivide1Bac = try! "(b - a) / c".toTerm()
        subtractDivide1Bca = try! "(b - c) / a".toTerm()
        subtractDivide1Cab = try! "(c - a) / b".toTerm()
        subtractDivide1CBA = try! "(c - b) / a".toTerm()
        
        // a / (b - c)
        subtractDivide2Abc = try! "a / (b - c)".toTerm()
        subtractDivide2Acb = try! "a / (c - b)".toTerm()
        subtractDivide2Bac = try! "b / (a - c)".toTerm()
        subtractDivide2Bca = try! "b / (c - a)".toTerm()
        subtractDivide2Cab = try! "c / (a - b)".toTerm()
        subtractDivide2CBA = try! "c / (b - a)".toTerm()
        
        abc = [
            addAbc,
            subtractAbc,
            multiplyAbc,
            divideAbc,
            addSubtractAbc,
            multiplyDivideAbc,
            multiplyAddAbc,
            addMultiplyAbc,
            multiplySubtract1Abc,
            multiplySubtract2Abc,
            subtractMultiplyAbc,
            divideAdd_Abc,
            addDivide1Abc,
            addDivide2Abc,
            divideSubtract1Abc,
            divideSubtract2Abc,
            subtractDivide1Abc,
            subtractDivide2Abc,
        ]
        permutations = [
            subtractBac,
            subtractCab,
            divideBac,
            divideCab,
            addSubtractAcb,
            addSubtractBca,
            multiplyDivideAcb,
            multiplyDivideBca,
            multiplyAddAcb,
            multiplyAddBca,
            addMultiplyAcb,
            addMultiplyBca,
            multiplySubtract1Acb,
            multiplySubtract1Bca,
            multiplySubtract2Bac,
            multiplySubtract2Cab,
            subtractMultiplyBac,
            subtractMultiplyAcb,
            subtractMultiplyCab,
            subtractMultiplyBca,
            subtractMultiplyCBA,
            divideAdd_Bac,
            divideAdd_Acb,
            divideAdd_Cab,
            divideAdd_Bca,
            divideAdd_CBA,
            addDivide1Acb,
            addDivide1Bca,
            addDivide2Bac,
            addDivide2Cab,
            divideSubtract1Acb,
            divideSubtract1Bac,
            divideSubtract1Bca,
            divideSubtract1Cab,
            divideSubtract1CBA,
            divideSubtract2Acb,
            divideSubtract2Bac,
            divideSubtract2Bca,
            divideSubtract2Cab,
            divideSubtract2CBA,
            subtractDivide1Acb,
            subtractDivide1Bac,
            subtractDivide1Bca,
            subtractDivide1Cab,
            subtractDivide1CBA,
            subtractDivide2Acb,
            subtractDivide2Bac,
            subtractDivide2Bca,
            subtractDivide2Cab,
            subtractDivide2CBA,
        ]
        super.init(allowedDifference: allowedDifference, name: "Algorithm based on variable terms")
    }
    
    override func computePermutation(a: Int, b: Int, c: Int, target: Int, solutions: inout Solutions) {
        let assignments = [
            Assignment(name: "a", value: a),
            Assignment(name: "b", value: b),
            Assignment(name: "c", value: c),
        ]

        for term in abc {
            do {
                try solutions.add(solution: Solution(term: term.print(assignments: assignments), result: term.eval(assignments: assignments)))
            } catch {
                // ignore!
            }
        }
        if (differentDiceNumbers(a: a, b: b, c: c)) {
            for term in permutations {
                do {
                    try solutions.add(solution: Solution(term: term.print(assignments: assignments), result: term.eval(assignments: assignments)))
                } catch {
                    // ignore!
                }
            }
        }
    }
}
