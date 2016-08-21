let StoredServiceKey = "PoppinsStoredServiceKey"

private let UnconfiguredServiceName = "Unconfigured"
private let DropboxServiceName = "Dropbox"

enum Service: CustomStringConvertible {
    case unconfigured
    case dropbox

    var description: String {
        switch self {
        case .unconfigured: return UnconfiguredServiceName
        case .dropbox: return DropboxServiceName
        }
    }

    init?(string: String?) {
        switch string {
        case .some(UnconfiguredServiceName): self = .unconfigured
        case .some(DropboxServiceName): self = .dropbox
        default: return nil
        }
    }
}
