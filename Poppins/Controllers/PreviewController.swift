import Foundation

class PreviewController {
    let path: String
    let size: CGSize
    var observer: ViewModelObserver?
    var data = Data()

    var viewModel: PreviewViewModel {
        return PreviewViewModel(gifData: data)
    }

    init(path: String, size: CGSize) {
        self.path = path
        self.size = size
    }

    func loadData() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            if let d = try? Data(contentsOf: URL(fileURLWithPath: self.path)) {
                self.data = d
                DispatchQueue.main.async { _ = self.observer?.viewModelDidChange() }
            }
        }
    }
}
