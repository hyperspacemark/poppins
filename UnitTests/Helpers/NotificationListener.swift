open class NotificationListener {
    var fired: Bool = false

    init(notificationName: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(getter: UIPreviewAction.handler), name: NSNotification.Name(rawValue: notificationName), object: .none)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open func handler() {
        fired = true
    }
}
