class AsyncQueue {
    fileprivate let queue = OperationQueue()

    init(name: String, maxOperations: Int) {
        queue.name = name
        queue.maxConcurrentOperationCount = maxOperations
    }

    func addOperation(_ operation: Operation) {
        queue.addOperation(operation)
    }

    func addOperationWithBlock(_ block: @escaping () -> ()) {
        queue.addOperation(block)
    }

    func finally(_ block: @escaping () -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { [unowned self] in
            self.queue.waitUntilAllOperationsAreFinished()
            block()
        }
    }
}
