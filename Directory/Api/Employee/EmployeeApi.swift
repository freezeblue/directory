import Foundation

struct GetEmployeeApi: HttpApi {
    private static let apis = [
        "sq-mobile-interview/employees.json",
        "sq-mobile-interview/employees_malformed.json",
        "sq-mobile-interview/employees_empty.json"
    ]

    var server: String { "https://s3.amazonaws.com/" }
    var path: String { GetEmployeeApi.apis[Int.random(in: 0 ..< GetEmployeeApi.apis.count)] }
    var method: String { "GET" }
    var body: Data? { nil }
    var headers: [String: String]? { nil }
}
