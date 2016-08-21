import UIKit
import MobileCoreServices

private let LastCheckedPasteboardVersionKey = "PoppinsLastCheckedPasteboardVersionKey"

let GIFType = CFBridgingRetain(kUTTypeGIF) as! String
let JPEGType = CFBridgingRetain(kUTTypeJPEG) as! String
let PNGType = CFBridgingRetain(kUTTypePNG) as! String

struct Pasteboard {
    static func fetchImageData() -> (data: Data, type: String)? {
        let systemPasteboard = UIPasteboard.general

        if let gif = systemPasteboard.data(forPasteboardType: GIFType) { return (gif, GIFType) }
        if let jpeg = systemPasteboard.data(forPasteboardType: JPEGType) { return (jpeg, JPEGType) }
        if let png = systemPasteboard.data(forPasteboardType: PNGType) { return (png, PNGType) }

        return .none
    }

    static var hasImageData :Bool {
        if !hasPasteboardChanged { return false }

        let systemPasteboard = UIPasteboard.general
        UserDefaults.standard.set(systemPasteboard.changeCount, forKey: LastCheckedPasteboardVersionKey)

        return systemPasteboard.contains(pasteboardTypes: [GIFType, JPEGType, PNGType])
    }

    fileprivate static var hasPasteboardChanged: Bool {
        let lastCheckedVersion = UserDefaults.standard.integer(forKey: LastCheckedPasteboardVersionKey)
        return lastCheckedVersion != UIPasteboard.general.changeCount
    }
}
