import Runes

class PoppinsCellController {
    let imageFetcher: ImageFetcher
    let path: String
    var observer: ViewModelObserver?
    var size = CGSize.zero

    var viewModel: PoppinsCellViewModel {
        didSet {
            observer?.viewModelDidChange()
        }
    }

    init(imageFetcher: ImageFetcher, path: String) {
        self.imageFetcher = imageFetcher
        self.path = path
        viewModel = PoppinsCellViewModel(image: .none)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func fetchImage(_ size: CGSize) {
        self.size = size
        if let image = imageFetcher.fetchImage(size, path: path) {
            viewModel = PoppinsCellViewModel(image: image)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(PoppinsCellController.cacheDidUpdate), name: NSNotification.Name(rawValue: "CacheDidUpdate"), object: .none)
        }
    }

    @objc func cacheDidUpdate() {
        if let image = imageFetcher.fetchImage(size, path: path) {
            viewModel = PoppinsCellViewModel(image: image)
            NotificationCenter.default.removeObserver(self)
        }
    }
}
