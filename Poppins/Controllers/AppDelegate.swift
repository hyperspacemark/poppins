import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow.ApplicationWindow
    var controller = ApplicationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : Any]?) -> Bool {
        if application.isUnitTesting() {
            return true
        }

        controller.configureLinkedService()

        window?.rootViewController = controller.rootViewController
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return controller.handleExternalURL(url)
    }
}
