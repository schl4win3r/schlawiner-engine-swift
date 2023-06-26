public struct Settings {
    static func defauls() -> Settings {
        Settings(timeout: 60, penalty: 5, retries: 3, numbers: 8, level: .medium)
    }
    
    var timeout: Int
    var penalty: Int
    var retries: Int
    var numbers: Int
    var level: Level
    
    init(timeout: Int, penalty: Int, retries: Int, numbers: Int, level: Level) {
        self.timeout = timeout
        self.penalty = penalty
        self.retries = retries
        self.numbers = numbers
        self.level = level
    }
}
