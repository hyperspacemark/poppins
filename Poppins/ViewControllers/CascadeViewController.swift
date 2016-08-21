import CoreData
import Cascade
import Gifu
import Result
import Runes

class CascadeViewController: UICollectionViewController {
    var controller: CascadeController?
    let popupViewManager = PopupViewManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavigationBarBackground"), for: .default)
        navigationItem.titleView = UIImage(named: "PoppinsTitle").map { UIImageView(image: $0) }

        let layout = collectionView?.collectionViewLayout as? CascadeLayout
        layout?.delegate = self
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

        NotificationCenter.default.addObserver(self, selector: #selector(CascadeViewController.sync), name: NSNotification.Name.UIApplicationDidBecomeActive, object: .none)
        sync()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchImages()

        if controller?.viewModel.shouldShowEmptyState ?? true {
            showEmptyState()
        }
    }

    @objc func sync() {
        controller?.syncWithTHECLOUD()

        if controller?.hasPasteboardImage ?? false {
            let alert = controller?.viewModel.alertControllerForImportingPasteboardImage(presentImportView)
            alert.map { self.present($0, animated: true, completion: .none) }
        }
    }

    private func fetchImages() {
        controller?.fetchImages()
        controller?.registerForChanges { inserted, updated, deleted in
            self.hideEmptyState()
            _ = self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItems(at: inserted)
                self.collectionView?.reloadItems(at: updated)
                self.collectionView?.deleteItems(at: deleted)
            }, completion: .none)
        }
    }

    private func showEmptyState() {
        let emptyStateViewController = EmptyStateViewController.create()
        emptyStateViewController.moveToParent(self) { self.collectionView?.backgroundView = $0 }
    }

    private func hideEmptyState() {
        let emptyStateViewController = childViewControllers.last as? EmptyStateViewController
        emptyStateViewController?.removeFromParent { self.collectionView?.backgroundView = .none }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller?.viewModel.numberOfImages ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PoppinsCell", for: indexPath) as! PoppinsCell
        cell.controller = controller?.cellControllerForIndexPath(indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItem indexPath: IndexPath) -> CGSize {
        return controller?.viewModel.imageSizeForIndexPath(indexPath) ?? CGSize(width: 1, height: 1)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gifItemSource = controller?.viewModel.gifItemSourceForIndexPath(indexPath)

        if let source = gifItemSource {
//            let activities: [UIActivity] = [FacebookMessengerActivity()]
            let activities: [UIActivity] = []
            let activityVC = UIActivityViewController(activityItems: [source], applicationActivities: activities)
            present(activityVC, animated: true, completion: .none)
        }
    }

    @IBAction func hold(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            let indexPath = collectionView?.indexPathForItem(at: point)
            let frame = (indexPath >>- { self.collectionView?.layoutAttributesForItem(at: $0) })?.frame
            let realFrame = frame >>- { self.collectionView?.convert($0, to: self.navigationController?.view) }
            let path = indexPath >>- { self.controller?.viewModel.imagePathForIndexPath($0) }
            let size = indexPath >>- { self.controller?.viewModel.imageSizeForIndexPath($0) }

            if
                let frame = realFrame,
                let path = path,
                let size = size
            {
                let previewViewController = popupViewManager.previewViewController(frame, path, size)
                self.present(previewViewController, animated: true, completion: nil)
            }
            
        } else if gesture.state == .ended {
            dismiss(animated: true, completion: popupViewManager.recyclePreview)
        }
    }

    private func presentImportView() {
        let importViewController = popupViewManager.importViewController <^> controller?.importController()
        importViewController?.importViewDidDismiss = popupViewManager.recycleImport
        importViewController.map { self.present($0, animated: true, completion: .none) }
    }
}

extension CascadeViewController: CascadeLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CascadeLayout, numberOfColumnsInSectionAtIndexPath indexPath: IndexPath) -> Int {
        return 2
    }
}
