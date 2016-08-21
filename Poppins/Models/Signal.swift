import Result
import Runes

class Signal<T> {
    private var observer: ((Result<T, NSError>) -> ())? = .none
    private var final: (() -> ())? = .none
    var filter: (T) -> T? = { $0 }

    func observe(_ observer: ((Result<T, NSError>) -> ())?) -> Signal<T> {
        self.observer = observer
        return self
    }

    func finally(_ f: (() -> ())?) -> Signal<T> {
        final = f
        return self
    }

    func push(_ t: T) {
        observer?(filter(t).toResult())
        final?()
    }

    func fail(_ error: NSError) {
        observer?(.failure(error))
    }
}
