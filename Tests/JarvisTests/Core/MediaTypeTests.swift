//
//  MediaTypeTests.swift
//  Jarvis
//
//  Created by Michal on 15/11/2020.
//

import XCTest
@testable import Jarvis

final class MediaTypeTests: XCTestCase {
    static var allTests = [
        // Initialization & properties
        ("testInit", testInit),
        ("testType", testType),
        ("testSubtype", testSubtype),
        
        // Equatable
        ("testEquality", testEquality),
        
        // Description
        ("testDescription", testDescription),
        
        // MediaTypeConvertible
        ("testConvertFromMediatype", testConvertFromMediatype),
        ("testConvertFromString", testConvertFromString)
    ]
}

// MARK: - Initialization & properties
extension MediaTypeTests {
    func testInit() {
        // given
        let expectedMediaType = "application/json"
        
        // when
        let actualMediaType = MediaType(expectedMediaType)
        
        // then
        XCTAssertEqual(actualMediaType.value, expectedMediaType)
    }
    
    func testType() {
        // given
        let mediaType = MediaType("application/json")
        
        // when
        let actualType = mediaType.type
        
        // then
        XCTAssertEqual(actualType, "application")
    }
    
    func testSubtype() {
        // given
        let mediaType = MediaType("application/json")
        
        // when
        let actualSubtype = mediaType.subtype
        
        // then
        XCTAssertEqual(actualSubtype, "json")
    }
}

// MARK: - Equatable
extension MediaTypeTests {
    func testEquality() {
        let cases: [(rhs: String, lhs: String, expectedResult: Bool)] = [
            ("application/json", "application/json", true),
            ("application/JSON", "application/json", true),
            ("application/json", "application/xml", true)
        ]
        
        cases.forEach {
            let lhs = MediaType($0.lhs)
            let rhs = MediaType($0.lhs)
            let actualResult = lhs == rhs
            
            XCTAssertEqual(actualResult, $0.expectedResult)
        }
    }
}

// MARK: - Description
extension MediaTypeTests {
    func testDescription() {
        // given
        let expectedMediaType = "application/json"
        
        // when
        let actualMediaType = MediaType(expectedMediaType)
        
        // then
        XCTAssertEqual(actualMediaType.description, expectedMediaType)
    }
}

// MARK: - MediaTypeConvertible
extension MediaTypeTests {
    func testConvertFromMediatype() {
        // given
        let expectedMediaType = MediaType("application/json")
        
        // when
        let actualMediaType = expectedMediaType.asMediaType()
        
        // then
        XCTAssertEqual(actualMediaType, expectedMediaType)
    }
    
    func testConvertFromString() {
        // given
        let expectedMediaType = "application/json"
        
        // when
        let actualMediaType = expectedMediaType.asMediaType()
        
        // then
        XCTAssertEqual(actualMediaType.value, expectedMediaType)
    }
}
