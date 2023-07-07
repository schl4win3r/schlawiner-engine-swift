public struct Settings {
    public static func defauls() -> Settings {
        Settings(timeout: 60, penalty: 5, retries: 3, numbers: 8, level: .medium)
    }
    
    public var timeout: Int
    public var penalty: Int
    public var retries: Int
    public var numbers: Int
    public var level: Level
    
    init(timeout: Int, penalty: Int, retries: Int, numbers: Int, level: Level) {
        self.timeout = timeout
        self.penalty = penalty
        self.retries = retries
        self.numbers = numbers
        self.level = level
    }
}
