import UIKit

class RootViewController: UIViewController {
    var controller: RootController?
    var activeViewController: UIViewController?

    var initialViewController: UIViewController {
        if controller?.isLinked ?? false {
            return cascadeViewController
        } else {
            return linkAccountViewController
        }
    }

    var linkAccountViewController: LinkAccountViewController {
        let storyboard = UIStoryboard(name: "Authentication", bundle: .none)
        let vc = storyboard.instantiateInitialViewController() as! LinkAccountViewController
        vc.controller = controller?.linkAccountController
        return vc
    }

    var cascadeViewController: UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! CascadeViewController
        vc.controller = controller?.cascadeController
        return nav
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showViewController(initialViewController)

        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.transitionToMainFlow), name: NSNotification.Name(rawValue: AccountLinkedNotificationName), object: .none)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func transitionToMainFlow() {
        let cascade = cascadeViewController
        cascade.moveToParent(self) { childView in
            childView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            view.sendSubview(toBack: childView)
        }

        transition(from: activeViewController!, to: cascade, duration: 0.33, options: UIViewAnimationOptions(), animations: {
            cascade.view.transform = CGAffineTransform.identity
            self.activeViewController?.view.frame = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.height)
        }) { _ in
            self.activeViewController?.removeFromParent(.none)
            self.activeViewController = cascade
        }
    }

    func showViewController(_ viewController: UIViewController) {
        viewController.moveToParent(self) { childView in
            childView.frame = view.bounds
            view.addSubview(childView)
        }

        activeViewController = viewController
    }
}
