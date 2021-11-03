//
//  BodyContentTests.swift
//  Jarvis
//
//  Created by Michal on 13/10/2020.
//

import XCTest
@testable import Jarvis

final class BodyContentTests: XCTestCase {
}

// MARK: - Initialization & properties
extension BodyContentTests {
    func testEmptyInit() {
        // given
        // when
        let actualBody = BodyContent()
        
        // then
        XCTAssertNil(actualBody.data)
        XCTAssertNil(actualBody.mediaType)
    }
    
    func testInit() {
        // given
        let expectedData = "data".data(using: .utf8)
        let expectedMediaType = "text/plain"
        
        // when
        let actualBody = BodyContent(data: expectedData, mediaType: expectedMediaType)
        
        // then
        XCTAssertEqual(actualBody.data, expectedData)
        XCTAssertEqual(actualBody.mediaType?.value, expectedMediaType)
    }
    
    func testJsonInit() {
        // given
        let jsonModel = Person(fullName: "Anakin Skywalker", age: 20)
        let expectedData = try! JSONEncoder().encode(jsonModel)
        let expectedMediaType = "application/json"
        
        // when
        let actualBody = try! BodyContent(json: jsonModel)
        
        // then
        XCTAssertEqual(actualBody.data, expectedData)
        XCTAssertEqual(actualBody.mediaType?.value, expectedMediaType)
    }
    
    func testStringInit() {
        // given
        let dataString = "data"
        let expectedData = dataString.data(using: .utf8)
        let expectedMediaType = "text/plain"
        
        // when
        let actualBody = BodyContent(string: dataString)
        
        // then
        XCTAssertEqual(actualBody.data, expectedData)
        XCTAssertEqual(actualBody.mediaType?.value, expectedMediaType)
    }
}

// MARK: - Description
extension BodyContentTests {
    func testDescription() {
        // given
        // when
        let bodyContent = BodyContent()
        // then
        XCTAssertFalse(bodyContent.description.isEmpty)
    }
}

// MARK: - Helpers
private extension BodyContentTests {
    struct Person: Codable {
        let fullName: String?
        let age: Int
    }
}
