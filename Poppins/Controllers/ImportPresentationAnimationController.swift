import UIKit
import Runes

class ImportPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let size: CGSize
    let duration: TimeInterval

    init(isPresenting: Bool, size: CGSize, duration: TimeInterval = 0.3) {
        self.isPresenting = isPresenting
        self.size = size
        self.duration = duration
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    var animationOptions: UIViewAnimationOptions {
        return [.allowAnimatedContent, .layoutSubviews, .curveEaseInOut]
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }

    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? ImportViewController
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let containerView = transitionContext.containerView

        let finalFrame = presentedController.map { transitionContext.finalFrame(for: $0) }
        let yOffset = (containerView.bounds).midY + size.height / 2
        presentedControllerView?.frame = containerView.bounds.centeredRectForSize(size, offset: CGPoint(x: 0, y: yOffset))
        presentedControllerView.map(containerView.addSubview)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: animationOptions, animations: {
            presentedControllerView?.frame = finalFrame ?? CGRect.zero
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }

    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)

        let containerView = transitionContext.containerView
        let yOffset = (containerView.bounds).midY + size.height / 2
        let finalFrame = containerView.bounds.centeredRectForSize(size, offset: CGPoint(x: 0, y: yOffset))

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: animationOptions, animations: {
            presentedControllerView?.frame = finalFrame
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }
}
