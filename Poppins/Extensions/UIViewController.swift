import UIKit

extension UIViewController {
    func moveToParent(_ parent: UIViewController, handleMove: (UIView) -> ()) {
        willMove(toParentViewController: parent)
        parent.addChildViewController(self)
        handleMove(view)
        didMove(toParentViewController: parent)
    }

    func removeFromParent(_ handleMove: (() -> ())?) {
        willMove(toParentViewController: .none)
        view.removeFromSuperview()
        handleMove?()
        removeFromParentViewController()
        didMove(toParentViewController: .none)
    }
}
