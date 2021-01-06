//
//  HttpHeadersTests.swift
//  Jarvis
//
//  Created by Michal on 12/10/2020.
//

import XCTest
@testable import Jarvis

final class HttpHeadersTests: XCTestCase {
    static var allTests = [
        // Initialization & properties
        ("testEmptyHeadersAfterInit", testEmptyHeadersAfterInit),
        ("testInitFromDictionary", testInitFromDictionary),
        ("testCount", testCount),
        
        // Modifying
        ("testAddField", testAddField),
        ("testAddExistingHeaders", testAddExistingHeaders),
        ("testAddCollectionOfFields", testAddCollectionOfFields),
        ("testAddMultipleFieldsWithSameName", testAddMultipleFieldsWithSameName),
        ("testSetByAddingNewField", testSetByAddingNewField),
        ("testSetByReplacingAllExisingFields", testSetByReplacingAllExisingFields),
        ("testRemoveField", testRemoveField),
        
        // Querying
        ("testGetFirst", testGetFirst),
        ("testGetLast", testGetLast),
        ("testGetAll", testGetAll),
        ("testGetAllNames", testGetAllNames),
        ("testGetAllValues", testGetAllValues),

        // Equatable
        ("testEqual", testEqual),
        
        // Description
        ("testDescription", testDescription)
    ]
}

// MARK: - Initialization & properties
extension HttpHeadersTests {
    func testEmptyHeadersAfterInit() {
        // given
        // when
        let headers = HttpHeaders()
        
        // then
        XCTAssertEqual(headers.fields.count, 0)
    }
    
    func testInitFromDictionary() {
        // given
        let dictionary = ["Content-Type" : "application/json"]
        
        // when
        let actualHeaders = HttpHeaders(dictionary: dictionary)
        
        // then
        XCTAssertEqual(actualHeaders.fields.count, dictionary.count)
        for (index, pair) in dictionary.enumerated() {
            XCTAssertEqual(pair.key, actualHeaders.fields[index].name)
            XCTAssertEqual(pair.value, actualHeaders.fields[index].value)
        }
    }
    
    func testCount() {
        // given
        let fields = [
            HttpHeaders.Field(name: "Content-Type", value: "application/json"),
            HttpHeaders.Field(name: "Accept-Type", value: "application/json")
        ]
        
        // when
        let actualHeaders = HttpHeaders(fields: fields)
        
        // then
        XCTAssertEqual(actualHeaders.count, fields.count)
    }
}

// MARK: - Modifying
extension HttpHeadersTests {
    func testAddField() {
        // given
        let actualField = HttpHeaders.Field(name: "Content-Type", value: "application/json")
        
        // when
        var headers = HttpHeaders()
        headers.add(actualField)
        
        // then
        let containsField = headers.fields.contains(where: { $0 == actualField })
        XCTAssertTrue(containsField)
    }
    
    func testAddExistingHeaders() {
        // given
        let expectedFields = [
            HttpHeaders.Field(name: "Content-Type", value: "application/json"),
            HttpHeaders.Field(name: "Accept-Type", value: "application/json")
        ]
        
        let existingHeaders = HttpHeaders(fields: expectedFields)

        // when
        var headers = HttpHeaders()
        headers.add(headers: existingHeaders)
        
        // then
        for (index, field) in expectedFields.enumerated() {
            XCTAssertEqual(headers.fields[index], field)
        }
    }
    
    func testAddCollectionOfFields() {
        // given
        let expectedFields = [
            HttpHeaders.Field(name: "Content-Type", value: "application/json"),
            HttpHeaders.Field(name: "Accept-Type", value: "application/json")
        ]
        
        // when
        var headers = HttpHeaders()
        headers.add(fields: expectedFields)
        
        // then
        for (index, field) in expectedFields.enumerated() {
            XCTAssertEqual(headers.fields[index], field)
        }
    }
    
    func testAddMultipleFieldsWithSameName() {
        // given
        let expectedFields = [
            HttpHeaders.Field(name: "Cache-Control", value: "no-cache"),
            HttpHeaders.Field(name: "Cache-Control", value: "no-store")
        ]
        
        // when
        var headers = HttpHeaders()
        headers.add(fields: expectedFields)
        
        // then
        for (index, field) in expectedFields.enumerated() {
            XCTAssertEqual(headers.fields[index], field)
        }
    }
    
    func testSetByAddingNewField() {
        // given
        let field1 = HttpHeaders.Field(name: "Cache-Control", value: "no-cache")
        let field2 = HttpHeaders.Field(name: "Accept-Type", value: "application/json")
        let expectedFields = [ field1, field2]
        
        var headers = HttpHeaders(fields: [field1])
        
        // when
        headers.set(field2)
        
        // then
        for (index, field) in expectedFields.enumerated() {
            XCTAssertEqual(headers.fields[index], field)
        }
    }
    
    func testSetByReplacingAllExisingFields() {
        // given
        let field1 = HttpHeaders.Field(name: "Cache-Control", value: "no-cache")
        let field2 = HttpHeaders.Field(name: "Cache-Control", value: "no-store")
        let expectedField = HttpHeaders.Field(name: "Cache-Control", value: "only-if-cached")
        
        var headers = HttpHeaders(fields: [field1, field2])
        
        // when
        headers.set(expectedField)
        
        // then
        for actualField in headers.fields {
            XCTAssertEqual(actualField, expectedField)
        }
    }
    
    func testRemoveField() {
        // given
        let field1 = HttpHeaders.Field(name: "Cache-Control", value: "no-cache")
        let field2 =  HttpHeaders.Field(name: "Content-Type", value: "application/json")
        let field3 = HttpHeaders.Field(name: "Cache-Control", value: "only-if-cached")
        let field4 = HttpHeaders.Field(name: "Accept-Type", value: "application/json")
        let expectedFields = [field2, field4]
        var headers = HttpHeaders(fields: [field1, field2, field3, field4])

        // when
        headers.remove(name: "Cache-Control")
        
        // then
        for (index, field) in expectedFields.enumerated() {
            XCTAssertEqual(headers.fields[index], field)
        }
    }
}

// MARK: - Querying
extension HttpHeadersTests {
    func testGetFirst() {
        // given
        let fields = [
            HttpHeaders.Field(name: "Cache-Control", value: "no-cache"),
            HttpHeaders.Field(name: "Cache-Control", value: "no-store")
        ]
        
        let headers = HttpHeaders(fields: fields)
        
        // when
        let actualValue = headers.first(name: "Cache-Control")
        
        // then
        XCTAssertEqual(actualValue, "no-cache")
    }
    
    func testGetLast() {
        // given
        let fields = [
            HttpHeaders.Field(name: "Cache-Control", value: "no-cache"),
            HttpHeaders.Field(name: "Cache-Control", value: "no-store")
        ]
        
        let headers = HttpHeaders(fields: fields)
        
        // when
        let actualResult = headers.last(name: "Cache-Control")
        
        // then
        XCTAssertEqual(actualResult, "no-store")
    }
    
    func testGetAll() {
        // given
        let fields = [
            HttpHeaders.Field(name: "Cache-Control", value: "no-cache"),
            HttpHeaders.Field(name: "Cache-Control", value: "no-store")
        ]
        
        let headers = HttpHeaders(fields: fields)
        
        // when
        let actualResult = headers.all(name: "Cache-Control")
        
        // then
        XCTAssertEqual(actualResult, ["no-cache", "no-store"])
    }
    
    func testGetAllNames() {
        // given
        let fields = [
            HttpHeaders.Field(name: "Content-Type", value: "application/json"),
            HttpHeaders.Field(name: "Accept-Type", value: "application/json")
        ]
        
        let headers = HttpHeaders(fields: fields)
        
        // when
        let actualResult = headers.names
        
        // then
        XCTAssertEqual(actualResult, ["Content-Type", "Accept-Type"])
    }
    
    func testGetAllValues() {
        // given
        let fields = [
            HttpHeaders.Field(name: "Content-Type", value: "application/json"),
            HttpHeaders.Field(name: "Cache-Control", value: "no-cache"),
        ]
        
        let headers = HttpHeaders(fields: fields)
        
        // when
        let actualResult = headers.values
        
        // then
        XCTAssertEqual(actualResult, ["application/json", "no-cache"])
    }
}

// MARK: - Equatable
extension HttpHeadersTests {
    func testEqual() {
        // given
        let field1 = HttpHeaders.Field(name: "Content-Type", value: "application/json")
        let field2 = HttpHeaders.Field(name: "Cache-Control", value: "no-cache")
        let field3 = HttpHeaders.Field(name: "Cache-Control", value: "no-store")
        
        let cases: [(lhs: HttpHeaders, rhs: HttpHeaders, expectedResult: Bool)] = [
            (lhs: HttpHeaders(fields: [field1, field2]), rhs: HttpHeaders(fields: [field1, field2]), expectedResult: true),
            (lhs: HttpHeaders(fields: [field1, field2]), rhs: HttpHeaders(fields: [field2, field1]), expectedResult: true),
            (lhs: HttpHeaders(fields: [field1, field2]), rhs: HttpHeaders(fields: [field1, field3]), expectedResult: false),
            (lhs: HttpHeaders(fields: [field2, field3]), rhs: HttpHeaders(fields: [field2]), expectedResult: false)
        ]
        
        for `case` in cases {
            // when
            let areEqual = `case`.lhs == `case`.rhs
            
            // then
            XCTAssertEqual(areEqual, `case`.expectedResult)
        }
    }
}

// MARK: - Description
extension HttpHeadersTests {
    func testDescription() {
        // given
        // when
        let headers = HttpHeaders()
        // then
        XCTAssertFalse(headers.description.isEmpty)
    }
}
