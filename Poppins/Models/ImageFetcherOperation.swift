import Foundation
import Runes

class ImageFetcherOperation: Operation {
    let path: String
    let size: CGSize
    let callback: (UIImage) -> ()

    init(path: String, size: CGSize, callback: @escaping (UIImage) -> ()) {
        self.path = path
        self.size = size
        self.callback = callback
        super.init()
    }

    override func main() {
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        let image = data >>- imageForData
        let scaledImage = image?.imageForSize(size)
        
        callback <^> scaledImage
    }
}
