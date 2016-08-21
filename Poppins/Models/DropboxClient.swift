import Result
import Runes

class DropboxClient: NSObject, DBRestClientDelegate, SyncClient {
    private let session: DBSession
    private let restClient: DBRestClient
    private let metaSignal = Signal<[FileInfo]>()
    private let shareURLSignal = Signal<String>()
    private let uploadSignal = Signal<Void>()
    private var fileSignals: [String:Signal<String>] = [:]

    init(session: DBSession) {
        self.session = session
        restClient = DBRestClient(session: session)
        super.init()
        restClient.delegate = self
    }

    func getFiles() -> Signal<[FileInfo]> {
        restClient.loadMetadata("/")
        return metaSignal
    }

    func getFile(_ path: String, destinationPath: String) -> Signal<String> {
        restClient.loadFile("/\(path)", intoPath: destinationPath)
        let sig = Signal<String>()
        fileSignals[path] = sig
        return sig.finally { _ = self.fileSignals.removeValue(forKey: path) }
    }

    func getShareURL(_ path: String) -> Signal<String> {
        restClient.loadSharableLink(forFile: "/\(path)", shortUrl: false)
        return shareURLSignal
    }

    func uploadFile(_ filename: String, localPath: String) -> Signal<Void> {
        restClient.uploadFile(filename, toPath: "/", withParentRev: nil, fromPath: localPath)
        return uploadSignal
    }

    func restClient(_ client: DBRestClient!, loadedFile destPath: String?) {
        if let destPath = destPath, let fileName = NSURL(fileURLWithPath: destPath).lastPathComponent {
            self.fileSignals[fileName]?.push(destPath)
        }
    }

    func restClient(_ client: DBRestClient!, loadFileFailedWithError error: Error?) {
        print(error)
    }

    func restClient(_ client: DBRestClient!, loadedMetadata metadata: DBMetadata?) {
        let fileMetadata = metadata?.contents as? [DBMetadata]
        let fileInfos: [FileInfo]? = fileMetadata?.map(FileInfo.fromDropboxMetadata)
        fileInfos.map(metaSignal.push)
    }

    func restClient(_ client: DBRestClient!, loadMetadataFailedWithError error: Error?) {
        print(error)

        if let error = error {
            metaSignal.fail(error as NSError)
        }
    }

    func restClient(_ restClient: DBRestClient!, loadSharableLinkFailedWithError error: Error?) {
        print(error)
    }

    func restClient(_ restClient: DBRestClient!, loadedSharableLink link: String!, forFile path: String!) {
        shareURLSignal.push(link)
    }

    func restClient(_ client: DBRestClient!, uploadFileFailedWithError error: Error?) {
        print(error)

        if let error = error {
            uploadSignal.fail(error as NSError)
        }
    }

    func restClient(_ client: DBRestClient!, uploadedFile destPath: String?, from sourcePath: String?, metadata: DBMetadata?) {
        uploadSignal.push()
    }
}

