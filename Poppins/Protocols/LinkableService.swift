protocol LinkableService {
    var type: Service { get }
    var client: SyncClient { get }

    func setup()
    func initiateAuthentication<T>(_: T)
    func finalizeAuthentication(_: URL) -> Bool
    func isLinked() -> Bool
    func unLink()
}
