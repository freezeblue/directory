import Foundation

// For Mocking URLSession
protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask : URLSessionDataTaskProtocol {}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}
// End for Mocking URLSession

enum HttpError {
    case networkError(code: Int)
    case clientError(reason: String)
}

typealias HttpCallback<T> = (T?, HttpError?) -> Void
typealias Headers = [String: String]

protocol HttpApi {
    var server: String { get }
    var path: String { get }
    var method: String { get }
    var body: Data? { get }
    var headers: Headers? { get }
}

extension HttpApi {
    func toRequest(with extraHeaders: Headers) -> URLRequest? {
        guard let url = URL(string: server + path) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        extraHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body

        return request
    }
}

protocol HttpProtocol {
    func setDefaultHeader(_ value: String, for key: String)
    func request<T: Codable>(_ api: HttpApi, callback: @escaping HttpCallback<T>)
}

final class HttpClient: HttpProtocol {
    private lazy var defaultHeader = Headers()
    private let urlSession: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.urlSession = session
    }

    func setDefaultHeader(_ value: String, for key: String) {
        defaultHeader[key] = value
    }

    func request<T: Codable>(_ api: HttpApi, callback: @escaping HttpCallback<T>) {
        guard let request = api.toRequest(with: defaultHeader) else {
            callback(nil, .clientError(reason: "bad request"))
            return
        }

        let task = urlSession.dataTask(with: request) { data, response, error in
            let result = self.handlResponse(data, response, error, T.self)
            DispatchQueue.main.async {
                callback(result.0, result.1)
            }
        }

        task.resume()
    }

    private func handlResponse<T: Codable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ type: T.Type) -> (T?, HttpError?) {
        guard error == nil, data != nil else {
            return (nil, .clientError(reason: error?.localizedDescription ?? "no data"))
        }

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            return (nil, .networkError(code: httpResponse.statusCode))
        } else {
            do {
                return (try JSONDecoder().decode(T.self, from: data!), nil)
            } catch let e {
                return (nil, .clientError(reason: e.localizedDescription))
            }
        }
    }
}
