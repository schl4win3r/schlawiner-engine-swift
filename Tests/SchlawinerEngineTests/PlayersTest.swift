@testable import SchlawinerEngine
import XCTest

final class PlayersTest: XCTestCase {

    func testCycle() throws {
        let foo = Player.human(name: "foo")
        let bar = Player.human(name: "bar")
        let players = Players(players: [foo, bar])
        
        XCTAssertEqual(foo, players.current)
        XCTAssertTrue(players.first())
        XCTAssertFalse(players.last())
        
        // round 1
        XCTAssertEqual(bar, players.next())
        XCTAssertEqual(bar, players.current)
        XCTAssertFalse(players.first())
        XCTAssertTrue(players.last())

        // round 2
        XCTAssertEqual(foo, players.next())
        XCTAssertEqual(foo, players.current)
        XCTAssertTrue(players.first())
        XCTAssertFalse(players.last())

        // round 3
        XCTAssertEqual(bar, players.next())
        XCTAssertEqual(bar, players.current)
        XCTAssertFalse(players.first())
        XCTAssertTrue(players.last())

        // round 4
        XCTAssertEqual(foo, players.next())
        XCTAssertEqual(foo, players.current)
        XCTAssertTrue(players.first())
        XCTAssertFalse(players.last())
    }
}
