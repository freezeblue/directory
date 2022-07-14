import XCTest
@testable import Directory

class HttpClientTests: XCTestCase {
    let url = "http://a.com/"
    let badUrl = "sfsaf   fewg"
    let urlSession = MockUrlSession()
    let api = MockApi()
    var httpClient: HttpClient!

    override func setUpWithError() throws {
        httpClient = HttpClient(session: urlSession)
    }

    func testGoodData() throws {
        let waitForSignal = expectation(description: "waitForSignal")

        let data = #"{"field": "good"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        urlSession.dataToReturn = data
        urlSession.httpResponseToReturn = response
        api.serverToReturn = url

        httpClient.setDefaultHeader("token", for: "auth")

        httpClient.request(api) { (data: MockData?, error: HttpError?) -> Void in
            XCTAssertEqual(data, MockData(field: "good"))
            XCTAssertNil(error)
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testBadData() throws {
        let waitForSignal = expectation(description: "waitForSignal")

        let data = #"{"bad": "good"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        urlSession.dataToReturn = data
        urlSession.httpResponseToReturn = response
        api.serverToReturn = url

        httpClient.request(api) { (data: MockData?, error: HttpError?) -> Void in
            XCTAssertNil(data)

            if case .clientError(let e) = error {
                XCTAssertEqual(e, "The data couldn’t be read because it is missing.")
            } else {
                XCTFail()
            }

            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testHttpError() throws {
        let waitForSignal = expectation(description: "waitForSignal")

        let data = #"{"field": "good"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 300, httpVersion: nil, headerFields: nil)

        urlSession.dataToReturn = data
        urlSession.httpResponseToReturn = response
        api.serverToReturn = url

        httpClient.request(api) { (data: MockData?, error: HttpError?) -> Void in
            XCTAssertNil(data)

            if case .networkError(let code) = error {
                XCTAssertEqual(code, 300)
            } else {
                XCTFail()
            }

            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testClientError() throws {
        let waitForSignal = expectation(description: "waitForSignal")

        let data = #"{"field": "good"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let error = MockError.error2

        urlSession.dataToReturn = data
        urlSession.httpResponseToReturn = response
        urlSession.errorToReturn = error
        api.serverToReturn = url

        httpClient.request(api) { (data: MockData?, error: HttpError?) -> Void in
            XCTAssertNil(data)

            if case .clientError(let e) = error {
                XCTAssertEqual(e, "The operation couldn’t be completed. (DirectoryTests.MockError error 1.)")
            } else {
                XCTFail()
            }

            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testBadUrl() throws {
        let waitForSignal = expectation(description: "waitForSignal")

        let data = #"{"field": "good"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        urlSession.dataToReturn = data
        urlSession.httpResponseToReturn = response
        api.serverToReturn = badUrl

        httpClient.request(api) { (data: MockData?, error: HttpError?) -> Void in
            XCTAssertNil(data)

            if case .clientError(let reason) = error {
                XCTAssertEqual(reason, "bad request")
            } else {
                XCTFail()
            }

            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testApiToRequest() {
        let waitForSignal = expectation(description: "waitForSignal")

        api.serverToReturn = url

        httpClient.setDefaultHeader("2", for: "y")
        httpClient.request(api) { (data: MockData?, error: HttpError?) -> Void in
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)

        XCTAssertEqual(urlSession.requestRecevied!.url, URL(string: url + "path")!)
        XCTAssertEqual(urlSession.requestRecevied!.httpMethod, "GET")
        XCTAssertEqual(urlSession.requestRecevied!.allHTTPHeaderFields, ["y": "2", "x": "1"])
        XCTAssertEqual(urlSession.requestRecevied!.httpBody, "test".data(using: .utf8))
    }
}

struct MockData: Codable, Equatable {
    let field: String
}
