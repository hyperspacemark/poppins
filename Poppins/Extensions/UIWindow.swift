import UIKit

extension UIWindow {
    class var ApplicationWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.black
        return window
    }
}
