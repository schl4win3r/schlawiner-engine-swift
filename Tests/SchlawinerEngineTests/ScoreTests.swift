@testable import SchlawinerEngine
import XCTest

final class ScoreTests: XCTestCase {

    func testNumberScore() throws {
        let foo = Player.human(name: "foo")
        let bar = Player.human(name: "bar")
        let players = Players(players: [foo, bar])
        var numberScore = NumberScore(number: 23, players: players)
        
        XCTAssertEqual(23, numberScore.number)
        XCTAssertEqual(emptyScore, numberScore[foo])
        XCTAssertEqual(emptyScore, numberScore[bar])

        let one = Score(term: "1", difference: 1)
        let two = Score(term: "2", difference: 2)
        numberScore[foo] = one
        numberScore[bar] = two

        XCTAssertEqual(one, numberScore[foo])
        XCTAssertEqual(two, numberScore[bar])
    }
    
    func testPlayerScore() throws {
        let numbers = Numbers(numbers: [23, 42])
        let foo = Player.human(name: "foo")
        var playerScore = PlayerScore(player: foo, numbers: numbers)
        
        XCTAssertEqual(foo, playerScore.player)
        XCTAssertEqual(emptyScore, playerScore[23])
        XCTAssertEqual(emptyScore, playerScore[42])

        let one = Score(term: "1", difference: 1)
        let two = Score(term: "2", difference: 2)
        playerScore[23] = one
        playerScore[42] = two

        XCTAssertEqual(one, playerScore[23])
        XCTAssertEqual(two, playerScore[42])
    }
    
    func testScoreboard() {
        let foo = Player.human(name: "foo")
        let bar = Player.human(name: "bar")
        let players = Players(players: [foo, bar])
        let numbers = Numbers(numbers: [23, 42])
        
        // one winner
        var scoreboard = Scoreboard(players: players, numbers: numbers)
        scoreboard[foo, 23] = Score(term: "1", difference: 1)
        scoreboard[foo, 42] = Score(term: "2", difference: 2)
        scoreboard[bar, 23] = Score(term: "3", difference: 3)
        scoreboard[bar, 42] = Score(term: "4", difference: 4)

        XCTAssertEqual(3, scoreboard.playerSums[foo])
        XCTAssertEqual(7, scoreboard.playerSums[bar])
        XCTAssertEqual(foo, scoreboard.winners()[0])

        // two winners
        scoreboard = Scoreboard(players: players, numbers: numbers)
        scoreboard[foo, 23] = Score(term: "1", difference: 1)
        scoreboard[foo, 42] = Score(term: "2", difference: 2)
        scoreboard[bar, 23] = Score(term: "2", difference: 2)
        scoreboard[bar, 42] = Score(term: "1", difference: 1)

        XCTAssertEqual(3, scoreboard.playerSums[foo])
        XCTAssertEqual(3, scoreboard.playerSums[bar])
        XCTAssertTrue(scoreboard.winners().contains(foo))
        XCTAssertTrue(scoreboard.winners().contains(bar))
    }
}
