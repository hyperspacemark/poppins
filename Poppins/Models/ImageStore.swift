import CoreData

struct ImageStore {
    let store: Store

    func newCachedImage() -> CachedImage? {
        return store.newObject("CachedImage")
    }

    func cachedImageForPath(_ path: String) -> CachedImage? {
        let request = CachedImage.fetchRequest()
        request.predicate = NSPredicate(format: "path = %@", path)
        return store.executeRequest(request).first as? CachedImage
    }

    func cachedImages() -> [CachedImage]? {
        let request = CachedImage.fetchRequest()
        return store.executeRequest(request) as? [CachedImage]
    }

    func saveCachedImage(_ cachedImage: CachedImage) {
        if !cachedImage.isUpdated { store.insertObject(cachedImage) }
        store.save()
    }

    func deleteCachedImage(_ cachedImage: CachedImage) {
        store.deleteObject(cachedImage)
        store.save()
    }

    func saveImageData(_ data: Data, name: String, aspectRatio: Double) -> String? {
        if let cachedImage = newCachedImage() {
            cachedImage.aspectRatio = aspectRatio
            cachedImage.path = name
            try? data.write(to: URL(fileURLWithPath: cachedImage.documentDirectoryPath), options: [.atomic])
            saveCachedImage(cachedImage)
            return cachedImage.documentDirectoryPath
        }

        return .none
    }
}
