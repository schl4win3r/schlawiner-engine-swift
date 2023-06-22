enum TermError: Error {
    case invalid(expression: String)
    case illegalDivision(left: Int, right: Int)
    case missingAssignment(names: [String])
    case unknownNode(node: Any)
}

enum Operator: CustomStringConvertible {
    case plus
    case minus
    case times
    case divided
    
    var description: String {
        switch self {
        case .plus: return "+"
        case .minus: return "-"
        case .times: return "*"
        case .divided: return "/"
        }
    }
    
    static func toOperator(token: String) -> Operator? {
        switch token {
        case "+": return .plus
        case "-": return .minus
        case "*": return .times
        case "/": return .divided
        default: return nil
        }
    }
}

let operatorPrecedence: [Operator: Int] = [.plus:0, .minus:0, .times:5, .divided:5]

struct Assignment {
    let name: String
    let value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}

protocol Node {
    var parent: Node? {get set}
    var left: Node? {get set}
    var right: Node? {get set}
}

class Value: Node {
    let value: Int
    var parent: Node? = nil
    var left: Node? = nil
    var right: Node? = nil
    
    init(value: Int) {
        self.value = value
    }
}

class Variable: Node {
    let name: String
    var parent: Node? = nil
    var left: Node? = nil
    var right: Node? = nil
    
    init(name: String) {
        self.name = name
    }
}

class Term: Node, Equatable, CustomStringConvertible {
    
    static func == (lhs: Term, rhs: Term) -> Bool {
        lhs.description == rhs.description
    }
    
    let op: Operator
    var parent: Node? = nil
    
    var left: Node? = nil {
        didSet {
            left?.parent = self
        }
    }
    
    var right: Node? = nil {
        didSet {
            right?.parent = self
        }
    }
    
    var description: String {
        print(assignments: [])
    }
    
    var complete: Bool {
        left != nil && right != nil
    }
    
    var values: [Int] {
        var values: [Int] = []
        inOrder(node: self)
        return values
        
        func inOrder(node: Node) {
            if let leftNode = node.left {
                inOrder(node: leftNode)
            }
            if let valueNode = node as? Value {
                values.append(valueNode.value)
            }
            if let rightNode = node.right {
                inOrder(node: rightNode)
            }
        }
    }
    
    var variables: [Variable] {
        var variables: [Variable] = []
        inOrder(node: self)
        return variables
        
        func inOrder(node: Node) {
            if let leftNode = node.left {
                inOrder(node: leftNode)
            }
            if let variableNode = node as? Variable {
                variables.append(variableNode)
            }
            if let rightNode = node.right {
                inOrder(node: rightNode)
            }
        }
    }
    
    init(op: Operator) {
        self.op = op
    }
    
    func eval(assignments: [Assignment]) throws -> Int {
        if !assignments.isEmpty {
            let unassigned = variables.filter { variable in
                assignments.first { assignment in
                    variable.name == assignment.name
                } == nil
            }
            if !unassigned.isEmpty {
                let names = unassigned.map { $0.name }
                throw TermError.missingAssignment(names: names)
            }
        }
        var stack = Stack<Int>()
        try postOrder(node: self)
        return try stack.pop()
        
        func postOrder(node: Node) throws {
            switch node {
            case let term as Term:
                if let leftNode = term.left {
                    try postOrder(node: leftNode)
                }
                if let rightNode = term.right {
                    try postOrder(node: rightNode)
                }
                let result: Int
                let right = try stack.pop()
                let left = try stack.pop()
                switch term.op {
                case .plus: result = left + right
                case .minus: result = left - right
                case .times: result = left * right
                case .divided:
                    if right == 0 || left % right != 0 {
                        throw TermError.illegalDivision(left: left, right: right)
                    }
                    result = Int(left / right)
                }
                stack.push(result)
            case let variable as Variable:
                let assignment = assignments.first { $0.name == variable.name }
                if let a = assignment {
                    stack.push(a.value)
                } else {
                    throw TermError.missingAssignment(names: [variable.name])
                }
            case let value as Value:
                stack.push(value.value)
            default: throw TermError.unknownNode(node: node)
            }
        }
    }
    
    func print(assignments: [Assignment]) -> String {
        var expression = ""
        do {
            try inOrder(node: self)
            return expression
        } catch {
            return error.localizedDescription
        }
        
        func inOrder(node: Node) throws {
            if let leftNode = node.left {
                try inOrder(node: leftNode)
            }
            switch node {
            case let term as Term: expression += " \(term.op.description) "
            case let variable as Variable:
                let needsBracket: Bool = needsBracket(node: node)
                if let parentLeftVariable = node.parent?.left as? Variable {
                    if needsBracket && variable === parentLeftVariable {
                        expression += "("
                    }
                }
                if let assignment = assignments.first(where: { $0.name == variable.name }) {
                    expression += String(assignment.value)
                } else {
                    expression += variable.name
                }
                if let parentRightVariable = node.parent?.right as? Variable {
                    if needsBracket && variable === parentRightVariable {
                        expression += ")"
                    }
                }
            case let value as Value:
                let needsBracket: Bool = needsBracket(node: node)
                if let parentLeftValue = node.parent?.left as? Value {
                    if needsBracket && value === parentLeftValue {
                        expression += "("
                    }
                }
                expression += String(value.value)
                if let parentRightValue = node.parent?.right as? Value {
                    if needsBracket && value === parentRightValue {
                        expression += ")"
                    }
                }
            default: throw TermError.unknownNode(node: node)
            }
            if let rightNode = node.right {
                try inOrder(node: rightNode)
            }
        }
        
        func needsBracket(node: Node) -> Bool {
            let parent = node.parent
            let grandparent = parent?.parent
            if let parentTerm = parent as? Term {
                if let grandparentTerm = grandparent as? Term {
                    return operatorPrecedence[parentTerm.op]! < operatorPrecedence[grandparentTerm.op]!
                }
            }
            return false
        }
    }
}
