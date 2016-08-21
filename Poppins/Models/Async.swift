private let queue = AsyncQueue(name: "PoppinsSyncQueue", maxOperations: 10)

class Async {
    fileprivate var _done: (() -> ())?

    class func map<U, T>(_ u: [U], f: @escaping (U) -> T) -> Async {
        let proc = Async()

        u.forEach { x in
            queue.addOperationWithBlock { _ = f(x) }
        }

        queue.finally { _ = proc._done?() }

        return proc
    }

    func done(_ f: (() -> ())) {
        _done = f
    }
}
