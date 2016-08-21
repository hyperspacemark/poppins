import UIKit

//class FacebookMessengerActivity: UIActivity {
//    var data: Data?
//
//    override class var activityCategory: UIActivityCategory {
//        return .share
//    }
//
//    override var activityType: UIActivityType? {
//        return .post
//    }
////    override var activityType: String? {
////        return UIActivityType(rawValue: "ActivityTypePostToFacebookMessenger")
////    }
//
//    @nonobjc override var activityType: UIActivityType? {
//        return UIActivityType(rawValue: "ActivityTypePostToFacebookMessenger")
//    }
//
//    override var activityTitle: String? {
//        return NSLocalizedString("Send to Facebook Messenger", comment: "fb messenger share message")
//    }
//
//    override var activityImage: UIImage? {
//        return UIImage(named: "MessengerIcon")
//    }
//
//    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
//        return true
//    }
//
//    override func prepare(withActivityItems activityItems: [Any]) {
//        data = activityItems.first as? Data
//    }
//
//    override func perform() {
//        if let data = data {
//            FBSDKMessengerSharer.shareAnimatedGIF(data, with: nil)
//            activityDidFinish(true)
//            return
//        } else {
//            activityDidFinish(false)
//        }
//    }
//}
