import Foundation
import UIKit
import Runes

class PreviewPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let startingFrame: CGRect
    let duration: TimeInterval

    init(isPresenting: Bool, startingFrame: CGRect, duration: TimeInterval = 0.3) {
        self.isPresenting = isPresenting
        self.startingFrame = startingFrame
        self.duration = duration
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    var animationOptions: UIViewAnimationOptions {
        return [.allowAnimatedContent, .layoutSubviews]
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }

    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? PreviewViewController
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let containerView = transitionContext.containerView

        let finalFrame = presentedController.map { transitionContext.finalFrame(for: $0) }
        presentedControllerView?.frame = startingFrame
        presentedController?.gifView.frame = CGRect(origin: CGPoint.zero, size: startingFrame.size)
        presentedControllerView?.alpha = 0
        presentedControllerView.map(containerView.addSubview)

        let midPoint = CGPoint(x: startingFrame.width / 2, y: startingFrame.height / 2)
        presentedController?.activityIndicator.frame = CGRect(origin: midPoint, size: presentedController?.activityIndicator.frame.size ?? CGSize.zero)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: animationOptions, animations: {
            presentedControllerView?.alpha = 1
            presentedControllerView?.frame = finalFrame ?? CGRect.zero
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }

    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: animationOptions, animations: {
            presentedControllerView?.alpha = 0
            presentedControllerView?.frame = self.startingFrame
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }
}
