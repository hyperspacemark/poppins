import UIKit
import Foundation

func imageForData(_ data: Data) -> UIImage? {
    return UIImage(data: data)
}

func imageSizeConstrainedByWidth(_ width: CGFloat, _ image: UIImage) -> CGSize {
    let aspectRatio = image.size.height / image.size.width
    return CGSize(width: width, height: width * aspectRatio)
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height / size.width
    }

    func imageForSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
