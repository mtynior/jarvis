//
//  ResponseTests.swift
//  Jarvis
//
//  Created by Michal on 27/10/2020.
//

import XCTest
@testable import Jarvis

final class ResponseTests: XCTestCase {
}

// MARK: - Initialization and properties
extension ResponseTests {
    func testDefaultInit() {
        // given
        // when
        let response = DataResponse()
        
        // then
        XCTAssertNil(response.request)
        XCTAssertEqual(response.statusCode, -1)
        XCTAssertNil(response.statusMessage)
        XCTAssertEqual(response.headers.count, 0)
        XCTAssertNil(response.body)
    }
    
    func testIsSuccess() {
        // given
        let cases: [(statusCode: Int, expectedResult: Bool)] = [
            (statusCode: 199, expectedResult: false),
            (statusCode: 200, expectedResult: true),
            (statusCode: 202, expectedResult: true),
            (statusCode: 299, expectedResult: true),
            (statusCode: 300, expectedResult: false)
        ]
        
        cases.forEach {
            // when
            let response = DataResponse(statusCode: $0.statusCode)
            
            // then
            XCTAssertEqual(response.isSuccess, $0.expectedResult)
        }
    }
    
    func testIsRedirection() {
        // given
        let cases: [(statusCode: Int, expectedResult: Bool)] = [
            (statusCode: 299, expectedResult: false),
            (statusCode: 300, expectedResult: true),
            (statusCode: 302, expectedResult: true),
            (statusCode: 399, expectedResult: true),
            (statusCode: 400, expectedResult: false)
        ]
        
        cases.forEach {
            // when
            let response = DataResponse(statusCode: $0.statusCode)
            
            // then
            XCTAssertEqual(response.isRedirection, $0.expectedResult)
        }
    }
}

// MARK: - Description
extension ResponseTests {
    func testDescription() {
        // given
        // when
        let response = DataResponse()
        // then
        XCTAssertFalse(response.description.isEmpty)
    }
}
