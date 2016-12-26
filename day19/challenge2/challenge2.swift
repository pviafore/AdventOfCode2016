public class Node {
    var value: Int
    init(value: Int) {
        self.value = value
    }

    var next: Node? = nil
    weak var previous: Node?
}

func createList(size: Int) -> Node {
    let head:Node = Node(value: 1)
    var tail:Node = head
    for index in 2...size {
        let node = Node(value:index)
        node.previous = tail
        tail.next = node
        tail = node
    }
    head.previous = tail
    tail.next = head
    return head
}

func removeSelf(node: Node) -> Node {
    let nextNode = node.next!
    let previousNode = node.previous!
    previousNode.next = nextNode
    nextNode.previous = previousNode
    return nextNode
}

func josephus(circleSize: Int)-> Int {
    var list: Node = createList(size: circleSize)
    for _ in 1...circleSize/2 {
        list=list.next!
    }
    for size in stride(from: circleSize, to: 1, by: -1) {
        list = removeSelf(node:list)
        if (size % 2 == 1){
            list=list.next!
        }
    }
    return list.value
}

print(josephus(circleSize: 3014603))
