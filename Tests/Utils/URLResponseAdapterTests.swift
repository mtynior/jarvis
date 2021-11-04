//
//  URLResponseAdapterTests.swift
//  Jarvis
//
//  Created by Michal on 28/10/2020.
//

import XCTest
@testable import Jarvis

final class URLResponseAdapterTests: XCTestCase {
    var adpater: URLResponseAdapter!
    
    override func setUp() {
        super.setUp()
        adpater = URLResponseAdapter()
    }
    
    override func tearDown() {
        super.tearDown()
        adpater = nil
    }
}

// MARK: - Map fields
extension URLResponseAdapterTests {
    func testMapStatusCode() {
        // given
        let expectedStatusCode = 200
        let testData = makeTestData(statusCode: expectedStatusCode)
        // when
        let response = adpater.map(httpUrlResponse: testData.httpResponse, data: nil, for: testData.request)
        
        // then
        XCTAssertEqual(response?.statusCode, expectedStatusCode)
    }
    
    func testMapStatusMessage() {
        // given
        let testData = makeTestData()
        // when
        let response = adpater.map(httpUrlResponse: testData.httpResponse, data: nil, for: testData.request)
        
        // then
        XCTAssertNotNil(response?.statusCode)
    }
    
    func testMapHeaders() {
        // given
        let expectedHeaders = [
            "Content-Type": "application/json",
            "User-Agent": "Jarvis"
        ]
        
        let testData = makeTestData(headers: expectedHeaders)
        // when
        let response = adpater.map(httpUrlResponse: testData.httpResponse, data: nil, for: testData.request)
        
        // then
        XCTAssertEqual(response?.headers.count, expectedHeaders.count)
        XCTAssertEqual(response?.headers.names.sorted(), expectedHeaders.keys.sorted())
        XCTAssertEqual(response?.headers.values.sorted(), expectedHeaders.values.sorted())
    }
}

// MARK: - Map Response Body
extension URLResponseAdapterTests {
    func testMapBodyData() {
        // given
        let testData = makeTestData()
        let expectedData = "Hello world".data(using: .utf8)
        
        // when
        let response = adpater.map(httpUrlResponse: testData.httpResponse, data: expectedData, for: testData.request)
        
        // then
        XCTAssertEqual(response?.body?.data, expectedData)
    }
    
    func testSkipMapBody() {
        // given
        let testData = makeTestData()
        
        // when
        let response = adpater.map(httpUrlResponse: testData.httpResponse, data: nil, for: testData.request)
        
        // then
        XCTAssertNil(response?.body)
    }
    
    func testMapBodyContentType() {
        // given
        let expectedContentType = "text/plain"
        let headers = [
            "Content-Type": expectedContentType,
            "User-Agent": "Jarvis"
        ]
        
        let testData = makeTestData(headers: headers)
        let expectedData = "Hello world".data(using: .utf8)
        
        // when
        let response = adpater.map(httpUrlResponse: testData.httpResponse, data: expectedData, for: testData.request)
        
        // then
        XCTAssertEqual(response?.body?.mediaType?.value, expectedContentType)
    }
}

// MARK: - Helpers
private extension URLResponseAdapterTests {
    func makeTestData(url: String = "https://httpbin.org/get", statusCode: Int = 200, headers: [String: String]? = nil) -> (request: Request, httpResponse: HTTPURLResponse) {
        let request = Request().url(url)
        let httpResponse = HTTPURLResponse(url: URL(string: url)!, statusCode: statusCode, httpVersion: nil, headerFields: headers)!
        
        return (request: request, httpResponse: httpResponse)
    }
}
