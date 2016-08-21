import Foundation
import Result
import Runes

private let SupportedFileExtensions = ["gif", "png", "jpg", "jpeg"]

class SyncEngine {
    let store: ImageStore
    var client: SyncClient

    init(imageStore: ImageStore, syncClient: SyncClient) {
        store = imageStore
        client = syncClient
    }

    func runSync() {
        _ = client.getFiles().observe { result in
            dispatch_to_user_initiated {
                let files = result.value?.filter {
                    let url = URL(fileURLWithPath: $0.path)
                    return SupportedFileExtensions.contains(url.pathExtension.lowercased())
                }

                self.processFiles <^> files
            }
        }
    }

    private func processFiles(fileInfos: [FileInfo]) {
        let cachedImages = store.cachedImages() ?? []

        let updatable: [CachedImage] = cachedImages.reduce([]) { accum, image in
            let filePaths = fileInfos.map { $0.path }
            if let index = filePaths.index(of: image.path) {
                if fileInfos[index].rev != image.rev {
                    image.rev = fileInfos[index].rev
                    return accum + [image]
                }
            }
            return accum
        }

        let creatable = fileInfos.filter { info in
            let paths = cachedImages.map { $0.path }
            return paths.index(of: info.path) == .none
        }

        let deletable = cachedImages.filter { image in
            let paths = fileInfos.map { $0.path }
            return paths.index(of: image.path) == .none
        }

        _ = creatable.map(createFile)
        _ = updatable.map(syncFile)
        _ = deletable.map(deleteFile)
    }

    private func createFile(fileInfo: FileInfo) {
        let cachedImage = store.newCachedImage()
        cachedImage?.path = fileInfo.path
        cachedImage?.rev = fileInfo.rev
        syncFile <^> cachedImage
    }

    fileprivate func syncFile(_ cachedImage: CachedImage) {
        let semaphore = DispatchSemaphore(value: 0)

        dispatch_to_main {
            _ = self.client.getFile(cachedImage.path, destinationPath: cachedImage.documentDirectoryPath).observe { result in
                dispatch_to_user_initiated {
                    let url = result.value.map { URL(fileURLWithPath: $0) }
                    let data = url.flatMap { try? Data(contentsOf: $0) }
                    let image = data.flatMap { imageForData($0) }
                    let aspectRatio = Double(image?.aspectRatio ?? 1.0)
                    cachedImage.aspectRatio = aspectRatio
                    dispatch_to_main {
                        self.getShareURL(cachedImage) {
                            self.store.saveCachedImage(cachedImage)
                            _ = DispatchSemaphore.signal(semaphore)
                        }
                    }
                }
            }
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

    fileprivate func getShareURL(_ cachedImage: CachedImage, callback: @escaping () -> ()) {
        client.getShareURL(cachedImage.path).observe { result in
            dispatch_to_main {
                result.value.map { cachedImage.shareURLPath = $0 }
                callback()
            }
        }
    }

    fileprivate func deleteFile(_ cachedImage: CachedImage) {
        store.deleteCachedImage(cachedImage)
    }
}
