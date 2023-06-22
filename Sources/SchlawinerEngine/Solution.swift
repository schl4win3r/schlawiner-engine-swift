let MAX_SOLUTION: Solution = Solution(term: "", result: Int.max)
let INVALID_SOLUTION: Solution = Solution(term: "Invalid term", result: Int.max)

struct Solution: CustomStringConvertible, Equatable {
    let term: String
    let result: Int
    
    var description: String {
        "\(term) = \(result)"
    }
}

public class Solutions {
    let target: Int
    let allowedDifference: Int
    var best: Solution = MAX_SOLUTION

    init(target: Int, allowedDifference: Int) {
        self.target = target
        self.allowedDifference = allowedDifference
    }

    func add(solution: Solution) {
        if solution.result >= target - allowedDifference && solution.result <= target + allowedDifference {
            if abs(solution.result - target) < abs(best.result - target) {
                best = solution
            }
        }
    }

    func bestSolution() -> Solution { best }

    func bestSolution(level: Level) -> Solution { best }
}
