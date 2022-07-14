import Foundation
@testable import Directory

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let callback: MockUrlSession.UrlSessionCallback

    var dataToReturn: Data?
    var httpResponseToReturn: HTTPURLResponse?
    var errorToReturn: Error?

    init(_ callback: @escaping MockUrlSession.UrlSessionCallback) {
        self.callback = callback
    }

    func resume() {
        if cancelCalled {
            cancelCalled = false
            return;
        }
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                if self.cancelCalled {
                    self.callback(nil, nil, MockError.error1)
                } else {
                    self.callback(self.dataToReturn, self.httpResponseToReturn, self.errorToReturn)
                }
            }
        }
    }

    var cancelCalled = false
    func cancel() {
        cancelCalled = true
    }
}
