func safeValue<T>(_ array: [T], index: Int) -> T? {
    return array.safeValue(index)
}

extension Array {
    func safeValue(_ index: Int) -> Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : .none
    }
}

func compact<T>(_ ts: [T?]) -> [T] {
    return ts.reduce([]) { accum, item in item.map { accum + [$0] } ?? accum }
}
