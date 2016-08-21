struct LinkAccountController {
    let manager: LinkManager

    func linkAccount(_ parent: UIViewController) {
        manager.setService(DropboxService())
        manager.setup()
        manager.initiateAuthentication(parent)
    }
}
