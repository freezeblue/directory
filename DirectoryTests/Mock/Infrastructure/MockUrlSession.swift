import Foundation
@testable import Directory

enum MockError: Error {
    case error1
    case error2
}

class MockUrlSession: URLSessionProtocol {
    typealias UrlSessionCallback = (Data?, URLResponse?, Error?) -> Void

    var dataToReturn: Data?
    var httpResponseToReturn: HTTPURLResponse?
    var errorToReturn: Error?
    var requestRecevied: URLRequest?

    func dataTask(with request: URLRequest, completionHandler: @escaping UrlSessionCallback) -> URLSessionDataTaskProtocol {
        requestRecevied = request
        let task = MockURLSessionDataTask(completionHandler)
        task.dataToReturn = dataToReturn
        task.httpResponseToReturn = httpResponseToReturn
        task.errorToReturn = errorToReturn
        return task
    }
}
