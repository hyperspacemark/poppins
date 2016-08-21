import Foundation

extension CachedImage {
    var documentDirectoryPath: String {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentURL!.appendingPathComponent(path).absoluteString
    }
}
