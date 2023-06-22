enum StackError : Error {
    case empty
}

protocol Stackable {
    associatedtype Element
    var isEmpty: Bool {get}
    func peek() throws -> Element
    mutating func push(_ element: Element)
    @discardableResult mutating func pop() throws -> Element
}

struct Stack<Element>: Stackable where Element: Equatable {
    private var storage = [Element]()
    var isEmpty: Bool {
        storage.isEmpty
    }

    func peek() throws -> Element {
        if let lastElement = storage.last {
            return lastElement
        } else {
            throw StackError.empty
        }
    }

    mutating func push(_ element: Element) { storage.append(element)  }

    mutating func pop() throws -> Element {
        if let lastElement = storage.popLast() {
            return lastElement
        } else {
            throw StackError.empty
        }
    }
}
