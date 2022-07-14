import Foundation

class BaseTableViewCellViewModel {
    private let data: Any?
    lazy var selectedSignal = Signal<Any?>(nil)

    init(data: Any? = nil) {
        self.data = data
    }

    func select() {
        selectedSignal.emit(data)
    }

    func getData<T>(type: T.Type) -> T? {
        return data as? T
    }
}
