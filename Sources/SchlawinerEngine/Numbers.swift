public class Numbers {
    public static func random(count: Int) -> Numbers {
        Numbers(numbers: Array(repeating: Int.random(in: 1...100), count: count))
    }
    
    let numbers: [Int]
    var index: Int
    var current: Int {
       numbers[index]
    }
    
    init(numbers: [Int]) {
        self.numbers = numbers
        self.index = 0
    }
    
    @discardableResult func next() -> Int {
        if hasNext() {
            index += 1
            return current
        } else {
            // stay at last number
            return current
        }
    }
    
    func hasNext() -> Bool {
        index < numbers.count - 1
    }
}
