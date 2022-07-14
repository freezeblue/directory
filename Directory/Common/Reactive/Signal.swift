import Foundation

final class Signal<T> {
    typealias Listener = ((T) -> Void)
    private var listener: Listener?

    private(set) var value: T {
        didSet {
            fire()
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func connect(_ listener: Listener?) {
        self.listener = listener
    }

    func connectAndEmit(_ listener: Listener?) {
        self.listener = listener
        fire()
    }

    func bind(to anotherSignal: Signal<T>) {
        anotherSignal.connect(emit)
    }

    func emit(_ newValue: T) {
        value = newValue
    }

    private func fire() {
        self.listener?(self.value)
    }
}

extension Signal where T == Void {
    func emit() {
        emit(())
    }
}
