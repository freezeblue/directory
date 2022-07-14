import XCTest
@testable import Directory

class SignalTests: XCTestCase {

    func testEmit() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        let signal = Signal("")

        signal.connect() {
            XCTAssertEqual($0, "test")
            waitForSignal.fulfill()
        }

        signal.emit("test")

        wait(for: [waitForSignal], timeout: 0.1)
    }

    func testConnectAndEmit() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        let signal = Signal("test")

        signal.connectAndEmit() {
            XCTAssertEqual($0, "test")
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 0.1)
    }

    func testEmitVoid() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        let signal = Signal(())

        signal.connect() {
            waitForSignal.fulfill()
        }

        signal.emit()

        wait(for: [waitForSignal], timeout: 0.1)
    }

    func testConnectAndEmitVoid() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        let signal = Signal(())

        signal.connectAndEmit() {
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 0.1)
    }

    func testBind() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        let signal = Signal("")
        let another = Signal("")

        signal.bind(to: another)

        signal.connect() {
            XCTAssertEqual($0, "test")
            waitForSignal.fulfill()
        }

        another.emit("test")

        wait(for: [waitForSignal], timeout: 0.1)
    }

    func testBindVoid() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        let signal = Signal(())
        let another = Signal(())

        signal.bind(to: another)

        signal.connect() {
            waitForSignal.fulfill()
        }

        another.emit()

        wait(for: [waitForSignal], timeout: 0.1)
    }
}
