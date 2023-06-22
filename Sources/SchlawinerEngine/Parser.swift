extension String {
    func toTerm() throws -> Term {
        let rpn = try infixToRpn(expression: self)
        if rpn.isEmpty {
            throw TermError.invalid(expression: self)
        }
        
        let builder = TermBuilder(expression: self)
        for token in rpn.reversed() {
            if let op = Operator.toOperator(token: token) {
                try builder.op(op: op)
            } else {
                if let value = Int(token) {
                    try builder.value(value: value)
                } else {
                    try builder.variable(name: token)
                }
            }
        }
        let term = try builder.build()
        if !term.complete {
            throw TermError.invalid(expression: self)
        }
        return term
    }
}

func infixToRpn(expression: String) throws -> [String] {
    return try convert(infix: split(expression: expression))
}

let OPS: Set<Character> = ["(", ")", "+", "-", "*", "/"]

func split(expression: String) -> [String] {
    var number = ""
    var tokens: [String] = []
    
    for c in expression {
        if OPS.contains(c) || c.isWhitespace {
            if !number.isEmpty {
                tokens.append(number)
                number = ""
            }
            if OPS.contains(c) {
                tokens.append(String(c))
            }
        } else {
            number.append(c)
        }
    }
    if !number.isEmpty {
        tokens.append(number)
    }
    return tokens
}

func convert(infix: [String]) throws -> [String] {
    var rpn: [String] = []
    var stack = Stack<String>()
    
    for token in infix {
        if let op = Operator.toOperator(token: token) {
            while !stack.isEmpty {
                let nextToken = try stack.peek()
                if let nextOp = Operator.toOperator(token: nextToken) {
                    if operatorPrecedence[op]! - operatorPrecedence[nextOp]! <= 0 {
                        rpn.append(try stack.pop())
                        continue
                    }
                }
                break
            }
            stack.push(token)
        } else {
            switch token {
            case "(": stack.push(token)
            case ")":
                while !stack.isEmpty {
                    if try stack.peek() != "(" {
                        rpn.append(try stack.pop())
                    } else {
                        break
                    }
                }
                let _ = try stack.pop()
            default: rpn.append(token)
            }
        }
    }
    while !stack.isEmpty {
        rpn.append(try stack.pop())
    }
    return rpn
}

class TermBuilder {
    let expression: String
    var terms = Stack<Term>()
    var current: Term? = nil
    
    init(expression: String) {
        self.expression = expression
    }
    
    func op(op: Operator) throws {
        let t = Term(op: op)
        if !terms.isEmpty {
            append(parent: try terms.peek(), child: t)
        }
        terms.push(t)
    }
    
    func variable(name: String) throws {
        try assign(node: Variable(name: name))
    }

    func value(value: Int) throws {
        try assign(node: Value(value: value))
    }

    func assign(node: Node) throws {
        if terms.isEmpty {
            throw TermError.invalid(expression: expression)
        }
        append(parent: try terms.peek(), child: node)
        while !terms.isEmpty {
            if try terms.peek().complete {
                current = try terms.pop()
            } else {
                break
            }
        }
    }
    
    func append(parent: Term, child: Node) {
        // assign right then left, order is important!
        if parent.right == nil {
            parent.right = child
        } else if parent.left == nil {
            parent.left = child
        }
    }
    
    func build() throws -> Term {
        if !terms.isEmpty || current == nil {
            throw TermError.invalid(expression: expression)
        }
        if let term = current {
            return term
        } else {
            throw TermError.invalid(expression: expression)
        }
    }
}
