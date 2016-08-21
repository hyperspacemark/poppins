import Runes

class DropboxService : LinkableService {
    let type: Service = .dropbox
    var client: SyncClient {
        return DropboxClient(session: DBSession.shared())
    }

    func setup() {
        let session = DBSession(appKey: Keys.dropboxKey, appSecret: Keys.dropboxSecret, root: kDBRootAppFolder)
        DBSession.setShared(session)
    }

    func initiateAuthentication<T>(_ controller: T) {
        if let viewController = controller as? UIViewController {
            DBSession.shared().link(from: viewController)
        }
    }

    func finalizeAuthentication(_ url: URL) -> Bool {
        let account = DBSession.shared().handleOpen(url)
        return account != .none
    }

    func isLinked() -> Bool {
        return DBSession.shared().isLinked()
    }

    func unLink() {
        DBSession.shared().unlinkAll()
    }
}
