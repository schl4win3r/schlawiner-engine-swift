import RegexBuilder

let diceMultipliers: [Int] = [1, 10, 100]
let numbersRegex = Regex {
    Capture {
        OneOrMore(.digit)
    } transform: {
        Int($0)
    }
}

enum DiceError : Error {
    case lessNumbers
    case moreNumbers
    case unusedNumbers
    case invalidNumber(number: String)
}

public struct Dice {
    public static func random() -> Dice {
        Dice(a: Int.random(in: 1...6), b: Int.random(in: 1...6), c: Int.random(in: 1...6))
    }

    let a: Int
    let b: Int
    let c: Int
    let diceNumbers: [Int]
    
    init(a: Int, b: Int, c: Int) {
        self.a = a
        self.b = b
        self.c = c
        self.diceNumbers = [a, b, c]
    }
    
    func validate(term: Term) throws {
        let numbers = term.values
        if numbers.count < diceNumbers.count {
            throw DiceError.lessNumbers
        } else if numbers.count > diceNumbers.count {
            throw DiceError.moreNumbers
        } else {
            let used = used(termNumbers: numbers)
            for b in used {
                if !b {
                    throw DiceError.unusedNumbers
                }
            }
        }
    }
    
    func used(expression: String) throws -> [Bool] {
        return used(termNumbers: try extractNumbers(expression: expression))
    }
    
    func extractNumbers(expression: String) throws -> [Int] {
        var numbers: [Int] = []
        let m = expression.matches(of: numbersRegex)
        for match in m {
            let (m, number) = match.output
            if let number {
                numbers.append(number)
            } else {
                throw DiceError.invalidNumber(number: String(m))
            }
        }
        return numbers
    }

    func used(termNumbers: [Int]) -> [Bool] {
        var used: [Bool] = Array(repeating: false, count: diceNumbers.count)
        number: for termNumber in termNumbers {
            for (index, diceNumber) in diceNumbers.enumerated() {
                if !used[index] {
                    for multiplier in diceMultipliers {
                        used[index] = termNumber == diceNumber * multiplier
                        if used[index] {
                            continue number
                        }
                    }
                }
            }
        }
        return used
    }
}
