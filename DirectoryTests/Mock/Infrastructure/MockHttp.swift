import Foundation
@testable import Directory

class MockHttp: HttpProtocol {

    var defaultHeader = [String: String]()
    func setDefaultHeader(_ value: String, for key: String) {
        defaultHeader[key] = value
    }

    var getCalledTimes = 0
    var responseToReturn: Any?
    var errorToReturn: HttpError?

    func request<T>(_ api: HttpApi, callback: @escaping HttpCallback<T>) where T : Decodable, T : Encodable {
        getCalledTimes += 1
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                callback(self.responseToReturn as? T, self.errorToReturn)
            }
        }
    }
}

class MockApi: HttpApi {
    var serverToReturn = "server/"
    var server: String { serverToReturn }

    var pathToReturn = "path"
    var path: String { pathToReturn }

    var method: String { "GET" }

    var body: Data? { "test".data(using: .utf8) }

    var headers: Headers? { ["x":"1"] }
}
