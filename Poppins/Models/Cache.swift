import Gifu

class Cache<T> {
    var cache: [String: T] = [:]

    func itemForKey(_ key: String) -> T? {
        return cache[key]
    }

    func setItem(_ item: T, forKey key: String) {
        cache[key] = item
    }

    func purge() {
        print("purging cache")
        cache = [:]
    }
}

class CachePurger {
    let cache: Cache<UIImage>

    init(cache: Cache<UIImage>) {
        self.cache = cache
        NotificationCenter.default.addObserver(self, selector: #selector(CachePurger.didRecieveMemoryWarning), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: .none)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func didRecieveMemoryWarning() {
        cache.purge()
    }

}
