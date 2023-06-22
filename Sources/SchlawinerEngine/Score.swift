let emptyScore = Score(term: "", difference: -1)

struct Score: Equatable {
    let term: String
    let difference: Int
    
    init(term: String, difference: Int) {
        self.term = term
        self.difference = difference
    }
}

struct NumberScore {
    let number: Int
    var scores: [Player:Score]
    
    init(number: Int, players: Players) {
        self.number = number
        self.scores = [:]
        for player in players.players {
            scores[player] = emptyScore
        }
    }
    
    subscript(player: Player) -> Score {
        get {
            scores[player]!
        }
        set(newValue) {
            scores[player] = newValue
        }
    }
}

struct PlayerScore {
    let player: Player
    var scores: [Int:Score]
    
    init(player: Player, numbers: Numbers) {
        self.player = player
        self.scores = [:]
        for number in numbers.numbers {
            scores[number] = emptyScore
        }
    }
    
    subscript(number: Int) -> Score {
        get {
            scores[number]!
        }
        set {
            scores[number] = newValue
        }
    }
}

struct Scoreboard {
    var numberScores: [NumberScore]
    var playerScores: [PlayerScore]
    var playerSums: [Player:Int]
    
    init(players: Players, numbers: Numbers) {
        numberScores = numbers.numbers.map {
            NumberScore(number: $0, players: players)
        }
        playerScores = players.players.map {
            PlayerScore(player: $0, numbers: numbers)
        }
        playerSums = [:]
        players.players.forEach {
            playerSums[$0] = 0
        }
    }
    
    subscript(player: Player, number: Int) -> Score {
        get {
            if let numberScore = numberScores.first(where: { $0.number == number }) {
                return numberScore[player]
            } else {
                return emptyScore
            }
        }
        set {
            if var numberScore = numberScores.first(where: { $0.number == number }) {
                numberScore[player] = newValue
            }
            if var playerScore = playerScores.first(where: { $0.player == player }) {
                playerScore[number] = newValue
            }
            if let current = playerSums[player] {
                playerSums[player] = current + newValue.difference
            }
        }
    }
    
    func winners() -> [Player] {
        if let min = playerSums.values.min() {
            let minSums = playerSums.filter { (_, sum) in sum == min }
            return Array(minSums.keys)
        } else {
            return []
        }
    }
}
