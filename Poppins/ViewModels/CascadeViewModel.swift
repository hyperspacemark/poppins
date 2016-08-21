import Result
import Runes

struct CascadeViewModel {
    let images: [CachedImage]

    var numberOfImages: Int {
        return images.count
    }

    var shouldShowEmptyState: Bool {
        return numberOfImages == 0
    }

    func imagePathForIndexPath(_ indexPath: IndexPath) -> String? {
        return images.safeValue(indexPath.row)?.documentDirectoryPath
    }

    func imageSizeForIndexPath(_ indexPath: IndexPath) -> CGSize? {
        let cachedImage = images.safeValue(indexPath.row)
        return CGSize(width: 1, height: cachedImage?.aspectRatio ?? 1)
    }

    func gifItemSourceForIndexPath(_ indexPath: IndexPath) -> GifItemSource? {
        if let path = imagePathForIndexPath(indexPath), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return GifItemSource(data: data, url: shareURLForIndexPath(indexPath))
        } else {
            return nil
        }
    }

    func shareURLForIndexPath(_ indexPath: IndexPath) -> URL? {
        let cachedImage = images.safeValue(indexPath.row)
        return cachedImage?.shareURLPath >>- { URL(string: "\($0)&raw=1") }
    }

    func alertControllerForImportingPasteboardImage(_ importCallback: @escaping () -> ()) -> UIAlertController {
        let title = NSLocalizedString("New Image Found!", comment: "")
        let message = NSLocalizedString("Would you like to save the image in your pasteboard?", comment: "")

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: .none)
        let positiveAction = UIAlertAction(title: "Yes", style: .default) { _ in
            importCallback()
        }
        
        alert.addAction(positiveAction)
        alert.addAction(cancelAction)
        return alert
    }
}
