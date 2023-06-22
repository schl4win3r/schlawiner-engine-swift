import Foundation

class Game {
    let name: String
    let players: Players
    let numbers: Numbers
    let algorithm: Algorithm
    let settings: Settings
    var scoreboard: Scoreboard
    let id: UUID
    var dice: Dice
    var canceled: Bool
    
    init(name: String, players: Players, numbers: Numbers, algorithm: Algorithm, settings: Settings) {
        self.name = name
        self.players = players
        self.numbers = numbers
        self.algorithm = algorithm
        self.settings = settings
        self.scoreboard = Scoreboard(players: players, numbers: numbers)
        self.id = UUID()
        self.dice = Dice.random()
        self.canceled = false
    }
    
    func next() {
        players.next()
        if (players.first()) {
            numbers.next()
        }
    }
    
    func isOver() -> Bool {
        return (numbers.hasNext() || !players.last()) && !canceled
    }
    
    func dice(dice: Dice = Dice.random()) {
        self.dice = dice
    }
    
    func retry() -> Bool {
        if players.current.human && players.current.retries > 0 {
            // TODO players.current.retry()
            dice()
            return true
        } else {
            return false
        }
    }
    
    func skip() {
        scoreboard[players.current, numbers.current] = Score(term: "Skipped", difference: settings.penalty)
    }
    
    func timeout() {
        scoreboard[players.current, numbers.current] = Score(term: "Timeout", difference: settings.penalty)
    }
    
    func cancel() {
        self.canceled = true
    }
    
    func calculate(expression: String) throws -> Calculation {
        let term = try expression.toTerm()
        try dice.validate(term: term)
        let result = try term.eval(assignments: [])
        let difference = abs(result - numbers.current)
        if difference > 0 {
            let solutions = algorithm.compute(a: dice.a, b: dice.b, c: dice.c, target: numbers.current)
            return Calculation(term: term, target: numbers.current, bestSolution: solutions.bestSolution())
        } else {
            return Calculation(
                term: term,
                target: numbers.current,
                bestSolution: Solution(term: term.print(assignments: []), result: result)
            )
        }
    }
    
    func solve() -> Solution {
        algorithm.compute(a: dice.a, b: dice.b, c: dice.c, target: numbers.current).bestSolution(level: settings.level)
    }
        

    func score(score: Score) {
        scoreboard[players.current, numbers.current] = score
    }
}
