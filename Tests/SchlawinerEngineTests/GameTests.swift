@testable import SchlawinerEngine
import XCTest

final class GameTests: XCTestCase {

    func testHumanVsComputerDraw() throws {
        let foo = Player.human(name: "foo")
        let computer = Player.computer(name: "computer")
        var settings = Settings.defauls(); settings.level = .hard
        let game = Game(
            name: "test-game",
            players: Players(players: [foo, computer]),
            numbers: Numbers(numbers: [16, 23, 42]),
            algorithm: OperationAlgorithm(),
            settings: settings
        )
        
        // ------------------------------------------------------ 16
        game.dice(dice: Dice(a: 1, b: 2, c: 3))

        // human
        var calculation = try game.calculate(expression: "10 + 2 * 3")
        game.score(score: Score(term: "10 + 2 * 3", difference: try calculation.difference()))

        // computer
        game.next()
        var solution = game.solve()
        game.score(score: Score(term: solution.term, difference: abs(solution.result - game.numbers.current)))

        // ------------------------------------------------------ 23
        game.dice(dice: Dice(a: 4, b: 3, c: 1))

        // human
        game.next()
        calculation = try game.calculate(expression: "30 - 10 + 4")
        game.score(score: Score(term: "30 - 10 + 4", difference: try calculation.difference()))

        // computer
        game.next()
        solution = game.solve()
        game.score(score: Score(term: solution.term, difference: abs(solution.result - game.numbers.current)))

        // ------------------------------------------------------ 42
        game.dice(dice: Dice(a: 2, b: 5, c: 6))

        // human
        game.next()
        calculation = try game.calculate(expression: "50 - 6 - 2")
        game.score(score: Score(term: "50 - 6 - 2", difference: try calculation.difference()))

        // computer
        game.next()
        solution = game.solve()
        game.score(score: Score(term: solution.term, difference: abs(solution.result - game.numbers.current)))

        // ------------------------------------------------------ game over
        let fooScore = game.scoreboard.playerSums[foo]
        let computerScore = game.scoreboard.playerSums[computer]
        XCTAssertEqual(fooScore, computerScore)
        XCTAssertEqual(2, game.scoreboard.winners().count)
        XCTAssertTrue(game.scoreboard.winners().contains(foo))
        XCTAssertTrue(game.scoreboard.winners().contains(computer))
    }
}
