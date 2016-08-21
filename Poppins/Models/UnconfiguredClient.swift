struct UnconfiguredClient: SyncClient {
    func getFiles() -> Signal<[FileInfo]> {
        return Signal<[FileInfo]>()
    }

    func getFile(_ path: String, destinationPath: String) -> Signal<String> {
        return Signal<String>()
    }

    func getShareURL(_ path: String) -> Signal<String> {
        return Signal<String>()
    }

    func uploadFile(_ filename: String, localPath: String) -> Signal<Void> {
        return Signal<Void>()
    }
}
