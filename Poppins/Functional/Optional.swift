import Foundation
import Result

extension Optional {
    func toResult() -> Result<Wrapped, NSError> {
        switch self {
        case let .some(x): return .success(x)
        case .none: return .failure(NSError(domain: "", code: 0, userInfo: .none))
        }
    }
}
