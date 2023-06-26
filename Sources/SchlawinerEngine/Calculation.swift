public struct Calculation {
    let term: Term
    let target: Int
    let bestSolution: Solution
    
    var bestDifference: Int {
        abs(bestSolution.result - target)
    }
    
    init(term: Term, target: Int, bestSolution: Solution) {
        self.term = term
        self.target = target
        self.bestSolution = bestSolution
    }
    
    func difference() throws -> Int {
        abs(try term.eval(assignments: []) - target)
    }
    
    func best() throws -> Bool {
        try difference() == 0 || difference() == bestDifference
    }
}
