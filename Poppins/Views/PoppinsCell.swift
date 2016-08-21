import Runes
import CoreGraphics


class PoppinsCell: UICollectionViewCell, ViewModelObserver {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var shadowView: UIView?
    @IBOutlet weak var rootView: UIView?

    var cornerRadius: CGFloat = 6.0

    var shadowColor: UIColor = UIColor.black
    var shadowOpacity: Float = 0.5
    var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    var shadowSpread: CGFloat = 4

    var controller: PoppinsCellController? {
        didSet {
            controller?.observer = self
            viewModelDidChange()
            controller?.fetchImage <*> self.frame.size
        }
    }

    func viewModelDidChange() {
        DispatchQueue.main.async {
            self.imageView?.image = self.controller?.viewModel.image
            return
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCornerRadius()
        setupDropShadow()
    }
}

extension PoppinsCell {
    func setupCornerRadius() {
        rootView?.layer.cornerRadius = cornerRadius
    }

    func setupDropShadow() {
        shadowView?.layer.shadowColor = shadowColor.cgColor
        shadowView?.layer.shadowOpacity = shadowOpacity
        shadowView?.layer.shadowOffset = shadowOffset
        shadowView?.layer.shadowRadius = shadowSpread
        shadowView?.layer.shouldRasterize = true
        shadowView?.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension PoppinsCell {
    override func prepareForInterfaceBuilder() {
        layoutSubviews()
    }
}
