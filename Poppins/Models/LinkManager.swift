import Result
import Runes

let AccountLinkedNotificationName = "PoppinsAccountLinked"
let ServiceKey = "PoppinsService"

class LinkManager: LinkableService {
    var service: LinkableService

    var type: Service {
        return service.type
    }

    var client: SyncClient {
        return service.client
    }

    init(service: LinkableService) {
        self.service = service
    }

    func setService(_ service: LinkableService) {
        self.service = service
    }

    func initiateAuthentication<T>(_ meta: T) {
        service.initiateAuthentication(meta)
    }

    func finalizeAuthentication(_ url: URL) -> Bool {
        let handled = service.finalizeAuthentication(url)
        if handled && isLinked() {
            NotificationCenter.default.post(name: Notification.Name(rawValue: AccountLinkedNotificationName), object: .none)
        }
        return handled
    }

    func setup() {
        service.setup()
    }

    func isLinked() -> Bool {
        return service.isLinked()
    }

    func unLink() {
        service.unLink()
    }
}
