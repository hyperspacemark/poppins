func curry<T, U, V>(_ f: @escaping (T, U) -> V) -> (T) -> (U) -> V {
    return { x in { f(x, $0) }}
}
