import MobileCoreServices

class GifItemSource: NSObject, UIActivityItemSource {
    let imageData: Data
    let url: URL?

    init(data: Data, url: URL?) {
        imageData = data
        self.url = url
        super.init()
    }

    class func create(_ data: Data, _ url: URL?) -> GifItemSource {
        return GifItemSource(data: data, url: url)
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return url ?? imageData
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        switch activityType {
        case UIActivityType.copyToPasteboard, UIActivityType.postToTwitter: return url
        default: return imageData
        }
    }

    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: String?) -> String {
        guard let activityType = activityType else {
            return kUTTypeGIF as String
        }

        switch UIActivityType(rawValue: activityType) {
        case UIActivityType.copyToPasteboard, UIActivityType.postToTwitter: return CFBridgingRetain(kUTTypeURL) as! String
        default: return CFBridgingRetain(kUTTypeGIF) as! String
        }
    }
}
