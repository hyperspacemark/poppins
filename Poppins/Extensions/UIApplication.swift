extension UIApplication {
    func isUnitTesting() -> Bool {
        let info = ProcessInfo.processInfo.environment
        let injectBundleURL = info["XCInjectBundle"].map { NSURL(fileURLWithPath: $0) }
        let isUnitTesting = injectBundleURL?.pathExtension == "xctest"
        return isUnitTesting
    }
}
