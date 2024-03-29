//
//  URLRequestAdapterTests.swift
//  Jarvis
//
//  Created by Michal on 28/10/2020.
//

import XCTest
@testable import Jarvis

final class URLRequestAdapterTests: XCTestCase {    
    var adpater: URLRequestAdapter!
    
    override func setUp() {
        super.setUp()
        adpater = URLRequestAdapter()
    }
    
    override func tearDown() {
        super.tearDown()
        adpater = nil
    }
}

// MARK: - Map URLs
extension URLRequestAdapterTests {
    func testMapFullUrl() {
        // given
        let expectedUrl = HttpUrl("https://httpbin.org/get")
        
        let request = Request()
            .url(expectedUrl)
        
        let configuration = HttpClient.Configuration.default
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.url, expectedUrl.fullUrl)
    }
    
    func testMapEndpoint() {
        // given
        let expectedUrl = URL(string: "https://httpbin.org/get")!
        
        let request = Request()
            .endpoint("get")
        
        let configuration = HttpClient.Configuration(baseUrl: HttpUrl("https://httpbin.org/"))
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.url, expectedUrl)
    }
    
    func testMapNilUrl() {
        // given
        let request = Request()
        let configuration = HttpClient.Configuration.default
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertNil(urlRequest)
    }
    
    func testURLWithQueryParameters() {
        // given
        let expectedUrl = HttpUrl("https://httpbin.org/get?api_key=123abc9983&id=1313")
        
        let request = Request()
            .url(expectedUrl)
            .addQueryParameter(name: "api_key", value: "123abc9983")
            .addQueryParameter(name: "id", value: "1313")

        let configuration = HttpClient.Configuration.default
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.url, expectedUrl.fullUrl)
    }
    
    func testURLQueryParametersEncoding() {
        // given
        let expectedUrl = HttpUrl("https://httpbin.org/get?api_key=123abc9983&question=Luke%20%26%20Leia%20are%20you%20ok?!")
        
        let request = Request()
            .url(expectedUrl)
            .addQueryParameter(name: "api_key", value: "123abc9983")
            .addQueryParameter(name: "question", value: "Luke & Leia are you ok?!")

        let configuration = HttpClient.Configuration.default
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.url, expectedUrl.fullUrl)
    }
}

// MARK: - Map Request fields
extension URLRequestAdapterTests {
    func testMapHeaders() {
        // given
        let request = Request()
            .url("https://httpbin.org/get")
            .addHeader(name: "Content-Type", value: "application/json")
            .addHeader(name: "User-Agent", value: "Jarvis")
        
        let configuration = HttpClient.Configuration()
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?.count, request.headers.count)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?.keys.sorted(), request.headers.names.sorted())
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?.values.sorted(), request.headers.values.sorted())
    }
    
    func testMapMethod() {
        // given
        let request = Request()
            .url("https://httpbin.org/put")
            .method(.put)
        
        let configuration = HttpClient.Configuration()
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.httpMethod?.uppercased(), request.method.rawValue.uppercased())
    }
}

// MARK: - Map Body
extension URLRequestAdapterTests {
    func testMapBodyData() {
        // given
        let requestBody = BodyContent(string: "Hello world")
        
        let request = Request()
            .url("https://httpbin.org/post")
            .method(.post)
            .body(requestBody)
        
        let configuration = HttpClient.Configuration()
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.httpBody, requestBody.data)
    }
    
    func testMapContentTypeHeader() {
        // given
        let requestBody = BodyContent(string: "Hello world")
        
        let request = Request()
            .url("https://httpbin.org/post")
            .method(.post)
            .body(requestBody)
        
        let configuration = HttpClient.Configuration()
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], requestBody.mediaType?.value)
    }
    
    func testSkipMapContentTypeHeader() {
        // given
        let expectedHeaderValue = "application/json"
        let requestBody = BodyContent(string: "Hello world")
        
        let request = Request()
            .url("https://httpbin.org/post")
            .method(.post)
            .addHeader(name: "Content-Type", value: expectedHeaderValue)
            .body(requestBody)
        
        let configuration = HttpClient.Configuration()
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], expectedHeaderValue)
    }
}

// MARK: - Map other options
extension URLRequestAdapterTests {
    func testMapOtherOptions() {
        // given
        let request = Request()
            .url("https://httpbin.org/put")
        
        let configuration = HttpClient.Configuration(isCellularAccessAllowed: false)
        
        // when
        let urlRequest = adpater.map(request: request, usingConfiguration: configuration)
        
        // then
        XCTAssertEqual(urlRequest?.allowsCellularAccess, configuration.isCellularAccessAllowed)
    }
}
