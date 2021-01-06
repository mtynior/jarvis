//
//  RequestTests.swift
//  Jarvis
//
//  Created by Michal on 12/10/2020.
//

import XCTest
@testable import Jarvis

final class RequestTests: XCTestCase {
    static var allTests = [
        // Init
        ("testDefaultInit", testDefaultInit),
        ("testURLInit", testURLInit),
        ("testStringURLInit", testStringURLInit),
        
        // Urls
        ("testUrl", testUrl),
        ("testEndpoint", testEndpoint),
        
        // Http methods
        ("testDefaultHttpMethod", testDefaultHttpMethod),
        ("testHttpMethod", testHttpMethod),
        ("testOption", testOption),
        ("testGet", testGet),
        ("testHead", testHead),
        ("testPost", testPost),
        ("testPut", testPut),
        ("testPatch", testPatch),
        ("testDelete", testDelete),
        ("testTrace", testTrace),
        ("testConnect", testConnect),
        
        // Headers
        ("testAddHeader", testAddHeader),
        ("testAddHeaders", testAddHeaders),
        ("testSetHeader", testSetHeader),
        ("testRemoveHeader", testRemoveHeader),
        
        // Body
        ("testBody", testConnect),
        
        // Description
        ("testDescription", testDescription)
    ]
}

// MARK: - Init
extension RequestTests {
    func testDefaultInit() {
        // given
        // when
        let request = Request()
        
        // then
        XCTAssertNil(request.target)
        XCTAssertEqual(request.method, .get)
        XCTAssertNil(request.body)
        XCTAssertTrue(request.headers.count == 0)
    }
    
    func testURLInit() {
        // given
        let expectedUrl = HttpUrl("https://apple.com")

        // when
        let request = Request(url: expectedUrl)
        
        // then
        XCTAssertEqual(request.target, .url(expectedUrl))
    }
    
    func testStringURLInit() {
        // given
        let stringUrl = "https://apple.com"
        let expectedUrl = HttpUrl(stringUrl)

        // when
        let request = Request(url: stringUrl)
        
        // then
        XCTAssertEqual(request.target, .url(expectedUrl))
    }
}

// MARK: - URLs
extension RequestTests {
    func testUrl() {
        // given
        let expectedUrl = HttpUrl("https://apple.com")
        
        // when
        let request = Request()
            .url(expectedUrl)
        
        // then
        XCTAssertEqual(request.target, .url(expectedUrl))
    }
    
    func testStringUrl() {
        // given
        let expectedUrl = HttpUrl("https://apple.com")
        
        // when
        let request = Request()
            .url("https://apple.com")
        
        // then
        XCTAssertEqual(request.target, .url(expectedUrl))
    }
    
    func testEndpoint() {
        // given
        let expectedEndpoint = "/authorize"
        
        // when
        let request = Request()
            .endpoint(expectedEndpoint)
        
        // then
        XCTAssertEqual(request.target, .endpoint(expectedEndpoint))
    }
}

// MARK: - HTTP methods
extension RequestTests {
    func testDefaultHttpMethod() {
        // given
        // when
        let request = Request()
        
        // then
        XCTAssertEqual(request.method, .get)
    }
    
    func testHttpMethod() {
        // given
        // when
        let request = Request()
            .method(.trace)
        
        // then
        XCTAssertEqual(request.method, .trace)
    }
    
    func testOption() {
        // given
        // when
        let request = Request()
            .option()
        
        // then
        XCTAssertEqual(request.method, .option)
    }
    
    func testGet() {
        // given
        // when
        let request = Request()
            .get()
        
        // then
        XCTAssertEqual(request.method, .get)
    }
    
    func testHead() {
        // given
        // when
        let request = Request()
            .head()
        
        // then
        XCTAssertEqual(request.method, .head)
    }
    
    func testPost() {
        // given
        // when
        let request = Request()
            .post(BodyContent())
        
        // then
        XCTAssertEqual(request.method, .post)
        XCTAssertNotNil(request.body)
    }
    
    func testPut() {
        // given
        // when
        let request = Request()
            .put(BodyContent())
        
        // then
        XCTAssertEqual(request.method, .put)
        XCTAssertNotNil(request.body)
    }
    
    func testPatch() {
        // given
        // when
        let request = Request()
            .patch(BodyContent())
        
        // then
        XCTAssertEqual(request.method, .patch)
        XCTAssertNotNil(request.body)
    }
    
    func testDelete() {
        // given
        // when
        let request = Request()
            .delete(BodyContent())
        
        // then
        XCTAssertEqual(request.method, .delete)
        XCTAssertNotNil(request.body)
    }
    
    func testTrace() {
        // given
        // when
        let request = Request()
            .trace()
        
        // then
        XCTAssertEqual(request.method, .trace)
    }
    
    func testConnect() {
        // given
        // when
        let request = Request()
            .connect()
        
        // then
        XCTAssertEqual(request.method, .connect)
    }
}

// MARK: - Headers
extension RequestTests {
    func testAddHeader() {
        // given
        let field1 = HttpHeaders.Field(name: "Content-Type", value: "application/json")
        let expectedHeaders = HttpHeaders(fields: [field1])
        
        // when
        let request = Request()
            .addHeader(name: "Content-Type", value: "application/json")
        
        // then
        XCTAssertEqual(request.headers, expectedHeaders)
    }
    
    func testAddHeaders() {
        // given
        let field1 = HttpHeaders.Field(name: "Content-Type", value: "application/json")
        let field2 = HttpHeaders.Field(name: "Accept-Type", value: "application/json")
        let expectedHeaders = HttpHeaders(fields: [field1, field2])
        
        // when
        let request = Request()
            .addHeaders(expectedHeaders)
        
        // then
        XCTAssertEqual(request.headers, expectedHeaders)
    }
    
    func testSetHeader() {
        // given
        let field1 = HttpHeaders.Field(name: "Content-Type", value: "application/json")
        let expectedHeaders = HttpHeaders(fields: [field1])
        
        // when
        let request = Request()
            .addHeader(name: "Content-Type", value: "application/xml")      // add header
            .setHeader(name: "Content-Type", value: "application/json")     // replace header value

        // then
        XCTAssertEqual(request.headers, expectedHeaders)
    }
    
    func testRemoveHeader() {
        // given
        
        // when
        let request = Request()
            .addHeader(name: "Content-Type", value: "application/json")
            .removeHeader(name: "Content-Type")

        // then
        XCTAssertEqual(request.headers.count, 0)
    }
}

// MARK: - Body
extension RequestTests {
    func testBody() {
        // given
        // when
        let request = Request()
            .body(BodyContent())
        
        // then
        XCTAssertNotNil(request.body)
    }
}

// MARK: - Description
extension RequestTests {
    func testDescription() {
        // given
        // when
        let request = Request()
        // then
        XCTAssertFalse(request.description.isEmpty)
    }
}