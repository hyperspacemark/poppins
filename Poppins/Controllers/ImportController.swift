struct ImportController {
    let imageData: Data
    let imageType: String
    let store: ImageStore
    let client: SyncClient

    var viewModel: ImportViewModel {
        return ImportViewModel(imageData: imageData, imageType: imageType)
    }

    func saveAndUploadImage(_ image: UIImage, name: String) {
        if let path = store.saveImageData(imageData, name: name, aspectRatio: Double(image.aspectRatio)) {
            client.uploadFile(name, localPath: path)
        }
    }
}
