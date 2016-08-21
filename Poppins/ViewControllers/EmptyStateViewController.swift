import UIKit

private let GiphyURLString = "http://www.giphy.com"

class EmptyStateViewController: UIViewController {
    @IBAction func navigateToGiphy() {
        UIApplication.shared.openURL(URL(string: GiphyURLString)!)
    }
}

extension EmptyStateViewController {
    static func create() -> EmptyStateViewController {
        return EmptyStateViewController(nibName: "EmptyState", bundle: .none)
    }
}
