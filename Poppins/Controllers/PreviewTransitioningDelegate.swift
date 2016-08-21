import UIKit

class PreviewTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let startingFrame: CGRect

    init(startingFrame: CGRect) {
        self.startingFrame = startingFrame
        super.init()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
       return PreviewPresentationController(presentedViewController: presented, presentingViewController: presenting!, frame: startingFrame)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PreviewPresentationAnimationController(isPresenting: true, startingFrame: startingFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PreviewPresentationAnimationController(isPresenting: false, startingFrame: startingFrame)
    }
}
