import UIKit
import Gifu

class ImportViewController: UIViewController {
    @IBOutlet weak var imageView: AnimatableImageView!
    @IBOutlet weak var imageNameField: UITextField!
    @IBOutlet weak var extensionPicker: UIPickerView!

    var controller: ImportController?
    var importViewDidDismiss: (() -> ())?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setup() {
        modalPresentationStyle = .custom
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 4;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let viewModel = controller?.viewModel {
            imageView.animate(withGIFData: viewModel.imageData)
            imageView.startAnimatingGIF()
            setImageType(viewModel.imageType)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(ImportViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: .none)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }

        let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval

        if let size = endFrame?.cgRectValue.size, let duration = duration {
            let yTotal = view.superview?.frame.height ?? 0
            let yOffset = view.frame.maxY - (yTotal - (size.height + 20))
            let newFrame = CGRect(origin: CGPoint(x: view.frame.origin.x, y: view.frame.origin.y - yOffset), size: view.frame.size)

            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.view.frame = newFrame
            }, completion: .none)
        }
    }

    @IBAction func save() {
        if let image = imageView.image {
            let row = extensionPicker.selectedRow(inComponent: ImportViewPickerDefaultComponent)
            let ext = pickerView(extensionPicker, titleForRow: row, forComponent: ImportViewPickerDefaultComponent)
            controller?.saveAndUploadImage(image, name: "\(imageNameField.text)\(ext)")
            dismiss(animated: true, completion: importViewDidDismiss)
        }
    }

    @IBAction func cancel() {
        dismiss(animated: true, completion: importViewDidDismiss)
    }
}

private let ImportViewPickerDefaultComponent = 0
extension ImportViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}

extension ImportViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch row {
        case 0: return ".gif"
        case 1: return ".png"
        case 2: return ".jpeg"
        default: return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label
    }
}

extension ImportViewController {
    func setImageType(_ type: String) {
        let row: Int
        switch type {
        case JPEGType: row = 1
        case PNGType: row = 2
        default: row = 0
        }
        extensionPicker.selectRow(row, inComponent: ImportViewPickerDefaultComponent, animated: true)
    }
}

extension ImportViewController {
    static func create() -> ImportViewController {
        return ImportViewController(nibName: "ImportView", bundle: .none)
    }
}
