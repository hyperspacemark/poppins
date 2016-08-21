import UIKit

class ImportPresentationController: UIPresentationController {
    let dimmingView = UIView()
    let size: CGSize

    init(presentedViewController: UIViewController!, presentingViewController: UIViewController!, size: CGSize) {
        self.size = size
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        dimmingView.frame = (containerView?.bounds)!
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = (containerView?.bounds)!
        dimmingView.addSubview(blurView)
        dimmingView.alpha = 0

        containerView?.addSubview(dimmingView)
        containerView?.addSubview(presentedView!)

        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: .none)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: .none)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView?.bounds
        return bounds?.centeredRectForSize(size) ?? .zero
    }
}
