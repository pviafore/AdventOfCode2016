func josephus(circleSize: Int, num: Int)-> Int {
    var last = 0
    for index in 2...circleSize {
        last=(last + num) % index 
    }
    return last + 1 
}

print(josephus(circleSize: 3014603, num:2))
