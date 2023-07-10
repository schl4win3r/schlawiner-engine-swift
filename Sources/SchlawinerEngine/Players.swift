public struct Player {
    public static func human(name: String) -> Player { Player(name: name, human: true, retries: 0) }
    public static func computer(name: String) -> Player { Player(name: name, human: false, retries: 0) }

    public let name: String
    public let human: Bool
    public var retries: Int
    
    init(name: String, human: Bool, retries: Int) {
        self.name = name
        self.human = human
        self.retries = retries
    }
    
    mutating func retry() {
        self.retries -= 1
    }
}

extension Player: Hashable {
    public static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name && lhs.human == rhs.human
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(human)
    }
}

public class Players {
    let players: [Player]
    var index: Int
    var current: Player {
       players[index]
    }

    public init(players: [Player]) {
        self.players = players
        self.index = 0
    }
    
    @discardableResult func next() -> Player {
        if index < players.count - 1 {
            index += 1
        } else {
            // start over
            index = 0
        }
        return current
    }
    
    func first() -> Bool { index == 0 }
    
    func last() -> Bool { index == players.count - 1 }
}
