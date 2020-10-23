//
//  HttpUrlTests.swift
//  Jarvis
//
//  Created by Michal on 13/10/2020.
//

import XCTest
@testable import Jarvis

final class HttpUrlTests: XCTestCase {
    static var allTests = [
        // Initialization & properties
        ("testInit", testInit),
        ("testInitFromString", testInitFromString),
        ("testInitFromURL", testInitFromURL),
        
        // Builder
        ("testSetScheme", testSetScheme),
        ("testSetHost", testSetHost),
        ("testSetPort", testSetPort),
        
        // Equatable
        ("testEquality", testEquality),
        
        // Description
        ("testDescription", testDescription)
    ]
}

// MARK: - Initialization & properties
extension HttpUrlTests {
    func testInit() {
        // given
        // when
        let actualUrl = HttpUrl()
        
        // then
        XCTAssertNotNil(actualUrl.urlComponents)
    }
    
    func testInitFromString() {
        // given
        let expectedScheme = "https"
        let expectedHost = "apple.com"
        let expectedPort = 80
        
        // when
        let actualUrl = HttpUrl("https://apple.com:80")
        
        // then
        XCTAssertNotNil(actualUrl.urlComponents)
        XCTAssertEqual(actualUrl.scheme, expectedScheme)
        XCTAssertEqual(actualUrl.host, expectedHost)
        XCTAssertEqual(actualUrl.port, expectedPort)
    }
    
    func testInitFromURL() {
        // given
        let expectedScheme = "https"
        let expectedHost = "apple.com"
        let expectedPort = 80
        let url = URL(string: "https://apple.com:80")
        
        // when
        let actualUrl = HttpUrl(url!)
        
        // then
        XCTAssertNotNil(actualUrl.urlComponents)
        XCTAssertEqual(actualUrl.scheme, expectedScheme)
        XCTAssertEqual(actualUrl.host, expectedHost)
        XCTAssertEqual(actualUrl.port, expectedPort)
    }
}

// MARK: - Builder
extension HttpUrlTests {
    func testSetScheme() {
        // given
        let expectedScheme = "https"
        
        // when
        let actualUrl = HttpUrl()
            .scheme(expectedScheme)

        // then
        XCTAssertEqual(actualUrl.scheme, expectedScheme)
    }
    
    func testSetHost() {
        // given
        let expectedHost = "apple.com"
        
        // when
        let actualUrl = HttpUrl()
            .host(expectedHost)

        // then
        XCTAssertEqual(actualUrl.host, expectedHost)
    }
    
    func testSetPort() {
        // given
        let testCases: [(portNumber: Int, expetedResult: Int)] = [
            (0, 1),
            (80, 80),
            (66500, 65535)
        ]
        
        testCases.forEach {
            // when
            let actualUrl = HttpUrl()
                .port($0.portNumber)
            
            // then
            XCTAssertEqual(actualUrl.port, $0.expetedResult)

        }
    }
}

// MARK: - Equatable
extension HttpUrlTests {
    func testEquality() {
        // given
        let testCases: [(lhs: HttpUrl, rhs: HttpUrl, expectedResult: Bool)] = [
            (lhs: HttpUrl(), rhs: HttpUrl(), expectedResult: true),
            (lhs: HttpUrl("https://apple.com"), rhs: HttpUrl("https://apple.com"), expectedResult: true),
            (lhs: HttpUrl("http://apple.com"), rhs: HttpUrl("https://apple.pl"), expectedResult: false),
            (lhs: HttpUrl("https://apple.com"), rhs: HttpUrl("http://apple.com"), expectedResult: false),
            (lhs: HttpUrl("HTTPS://APPLE.COM"), rhs: HttpUrl("https://apple.com"), expectedResult: true),
            (lhs: HttpUrl("https://apple.com"), rhs: HttpUrl("https://apple.com/"), expectedResult: true),
            (lhs: HttpUrl("https://apple.com:443"), rhs: HttpUrl("https://apple.com:227"), expectedResult: false),
            (lhs: HttpUrl("http://apple.com:80"), rhs: HttpUrl("http://apple.com"), expectedResult: true),
            (lhs: HttpUrl("https://apple.com:443"), rhs: HttpUrl("https://apple.com"), expectedResult: true)
        ]
        
        testCases.forEach {
            // when
            let actuaResult = $0.lhs == $0.rhs
            
            // then
            XCTAssertEqual(actuaResult, $0.expectedResult)
        }
    }
}

// MARK: - Description
extension HttpUrlTests {
    func testDescription() {
        // given
        // when
        let cases: [HttpUrl] = [
            HttpUrl("https://google.com"),
            HttpUrl(URL(string: "https://apple.com")!)
        ]
        
        // then
        cases.forEach {
            XCTAssertFalse($0.description.isEmpty)
        }
    }
}
