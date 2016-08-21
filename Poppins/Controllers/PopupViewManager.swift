class PopupViewManager {
    private var previewViewController: PreviewViewController?
    private var previewTransitionDelegate: PreviewTransitioningDelegate?
    private var importViewController: ImportViewController?
    private var importTransitionDelegate: ImportTransitioningDelegate?

    func previewViewController(_ startingFrame: CGRect, _ path: String, _ size: CGSize) -> PreviewViewController {
        previewTransitionDelegate = PreviewTransitioningDelegate(startingFrame: startingFrame)
        previewViewController = PreviewViewController.create()
        previewViewController?.transitioningDelegate = previewTransitionDelegate
        previewViewController?.controller = PreviewController(path: path, size: size)
        return previewViewController!
    }

    func recyclePreview() {
        previewTransitionDelegate = .none
        previewViewController?.controller = .none
        previewViewController = .none
    }

    func importViewController(_ controller: ImportController) -> ImportViewController {
        importTransitionDelegate = ImportTransitioningDelegate()
        importViewController = ImportViewController.create()
        importViewController?.transitioningDelegate = importTransitionDelegate
        importViewController?.controller = controller
        return importViewController!
    }

    func recycleImport() {
        importTransitionDelegate = .none
        importViewController?.controller = .none
        importViewController = .none
    }
}
