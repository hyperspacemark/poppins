import Foundation
import Runes

class ImageFetcher {
    let imageCache: Cache<UIImage>
    let purger: CachePurger
    let operationQueue: AsyncQueue
    var inProgress: [String] = []

    init() {
        imageCache = Cache<UIImage>()
        purger = CachePurger(cache: imageCache)
        operationQueue = AsyncQueue(name: "PoppinsCacheQueue", maxOperations: OperationQueue.defaultMaxConcurrentOperationCount)
        NotificationCenter.default.addObserver(self, selector: #selector(ImageFetcher.didReceiveMemoryWarning), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: .none)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func didReceiveMemoryWarning() {
        inProgress = []
    }

    func fetchImage(_ size: CGSize, path: String) -> UIImage? {
        if let image = imageCache.itemForKey(path) {
            return image
        } else {
            if size == CGSize.zero { return .none }

            dispatch_to_main {
                objc_sync_enter(self.inProgress)
                if self.inProgress.contains(path) { return }
                self.inProgress.append(path)
                objc_sync_exit(self.inProgress)
                
                let operation = ImageFetcherOperation(path: path, size: size) { image in
                    self.imageCache.setItem(image, forKey: path)
                    
                    dispatch_to_main {
                        objc_sync_enter(self.inProgress)
                        if let index = self.inProgress.index(of: path) {
                            self.inProgress.remove(at: index)
                        }
                        objc_sync_exit(self.inProgress)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "CacheDidUpdate"), object: .none)
                    }
                }
                
                self.operationQueue.addOperation(operation)
            }
            return .none
        }
    }
}
