import UIKit

class ImportTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let size: CGSize = CGSize(width: 216, height: 355)

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
       return ImportPresentationController(presentedViewController: presented, presentingViewController: presenting!, size: size)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImportPresentationAnimationController(isPresenting: true, size: size)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImportPresentationAnimationController(isPresenting: false, size: size)
    }
}
