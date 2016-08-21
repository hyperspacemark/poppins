class ApplicationController {
    let manager = LinkManager(service: UnconfiguredService())

    var linkedService: Service {
        get {
            let str = UserDefaults.standard.object(forKey: StoredServiceKey) as? String
            return Service(string: str) ?? .unconfigured
        }
        set {
            UserDefaults.standard.set(newValue.description, forKey: StoredServiceKey)
        }
    }

    var rootViewController: UIViewController {
        let vc = RootViewController()
        vc.controller = RootController(manager: manager)
        return vc
    }

    func configureLinkedService() {
        switch linkedService {
        case .dropbox: manager.setService(DropboxService())
        default: break
        }

        manager.setup()

        if !manager.isLinked() {
            NotificationCenter.default.addObserver(self, selector: "setLinkedService", name: NSNotification.Name(rawValue: AccountLinkedNotificationName), object: .none)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setLinkedService() {
        linkedService = manager.type
    }

    func handleExternalURL(_ url: URL) -> Bool {
        return manager.finalizeAuthentication(url)
    }
}
