class UnconfiguredService: LinkableService {
    let type: Service = .unconfigured
    let client: SyncClient = UnconfiguredClient()

    func setup() {}

    func initiateAuthentication<T>(_: T) {}

    func finalizeAuthentication(_: URL) -> Bool {
        return false
    }

    func isLinked() -> Bool {
        return false
    }

    func unLink() {}
}
