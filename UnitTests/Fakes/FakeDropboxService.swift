import Result

class FakeDropboxService: LinkableService {
    var lastCall: String = ""
    var controller: UIViewController?
    var url: URL?

    let type: Service = .dropbox
    let client: SyncClient = FakeDropboxSyncClient()

    func setup() {
        lastCall = "setup"
    }

    func initiateAuthentication<A>(_ controller: A) {
        lastCall = "connect"
        self.controller = controller as? UIViewController
    }

    func finalizeAuthentication(_ url: URL) -> Bool {
        lastCall = "handleURL"
        self.url = url
        return true
    }

    func isLinked() -> Bool {
        lastCall = "isLinked"
        return false
    }

    func unLink() {
        lastCall = "unlink"
    }
}

class FakeDropboxSyncClient: SyncClient {
    var lastCall: String = ""

    func getFiles() -> Signal<[FileInfo]> {
        lastCall = "getFiles"
        return Signal()
    }

    func getFile(_ path: String, destinationPath: String) -> Signal<String> {
        lastCall = "getFile"
        return Signal()
    }

    func getShareURL(_ path: String) -> Signal<String> {
        lastCall = "getShareURL"
        return Signal()
    }

    func uploadFile(_ filename: String, localPath: String) -> Signal<Void> {
        lastCall = "uploadFile"
        return Signal()
    }
}
