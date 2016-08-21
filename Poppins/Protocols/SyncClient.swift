protocol SyncClient {
    func getFiles() -> Signal<[FileInfo]>
    func getFile(_ path: String, destinationPath: String) -> Signal<String>
    func getShareURL(_ path: String) -> Signal<String>
    func uploadFile(_ filename: String, localPath: String) -> Signal<Void>
}
