//
//  QueryParametersTests.swift.swift
//  Jarvis
//
//  Created by Michal on 25/11/2021.
//

import XCTest
@testable import Jarvis

final class QueryParametersTests: XCTestCase {
}

// MARK: - Initialization & properties
extension QueryParametersTests {
    func testEmptyparametersAfterInit() {
        // given
        // when
        let queryParameters = QueryParameters()
        
        // then
        XCTAssertEqual(queryParameters.parameters.count, 0)
    }
    
    func testInitFromDictionary() {
        // given
        let dictionary = ["api_key": "1234-abcde-9876"]
        
        // when
        let actualQueryParameters = QueryParameters(dictionary: dictionary)
        
        // then
        XCTAssertEqual(actualQueryParameters.parameters.count, dictionary.count)
        for (index, pair) in dictionary.enumerated() {
            XCTAssertEqual(pair.key, actualQueryParameters.parameters[index].name)
            XCTAssertEqual(pair.value, actualQueryParameters.parameters[index].value)
        }
    }
    
    func testCount() {
        // given
        let parameters = [
            QueryParameters.Parameter(name: "api_key", value: "1234-abcde-9876"),
            QueryParameters.Parameter(name: "userId", value: "1313")
        ]
        
        // when
        let actualQueryParameters = QueryParameters(parameters: parameters)
        
        // then
        XCTAssertEqual(actualQueryParameters.count, parameters.count)
    }
}

// MARK: - Modifying
extension QueryParametersTests {
    func testAddParameter() {
        // given
        let actualQueryParameter = QueryParameters.Parameter(name: "api_key", value: "1234-abcde-9876")
        
        // when
        var queryParameters = QueryParameters()
        queryParameters.add(actualQueryParameter)
        
        // then
        let containsParameter = queryParameters.parameters.contains(where: { $0 == actualQueryParameter })
        XCTAssertTrue(containsParameter)
    }
    
    func testAddExistingparameters() {
        // given
        let expectedQueryParameters = [
            QueryParameters.Parameter(name: "api_key", value: "1234-abcde-9876"),
            QueryParameters.Parameter(name: "userId", value: "1313")
        ]
        
        let existingQueryParameters = QueryParameters(parameters: expectedQueryParameters)

        // when
        var actualParameters = QueryParameters()
        actualParameters.add(parameters: existingQueryParameters)
        
        // then
        for (index, Parameter) in expectedQueryParameters.enumerated() {
            XCTAssertEqual(actualParameters.parameters[index], Parameter)
        }
    }
    
    func testAddCollectionOfParameters() {
        // given
        let expectedQueryParameters = [
            QueryParameters.Parameter(name: "api_key", value: "1234-abcde-9876"),
            QueryParameters.Parameter(name: "userId", value: "1313")
        ]
        
        // when
        var actualQueryParameters = QueryParameters()
        actualQueryParameters.add(parameters: expectedQueryParameters)
        
        // then
        for (index, Parameter) in expectedQueryParameters.enumerated() {
            XCTAssertEqual(actualQueryParameters.parameters[index], Parameter)
        }
    }
    
    func testAddMultipleParametersWithSameName() {
        // given
        let expectedQueryParameters = [
            QueryParameters.Parameter(name: "pageNumber", value: "1"),
            QueryParameters.Parameter(name: "pageNumber", value: "2")
        ]
        
        // when
        var actualParameters = QueryParameters()
        actualParameters.add(parameters: expectedQueryParameters)
        
        // then
        for (index, Parameter) in expectedQueryParameters.enumerated() {
            XCTAssertEqual(actualParameters.parameters[index], Parameter)
        }
    }
    
    func testSetByAddingNewParameter() {
        // given
        let parameter1 = QueryParameters.Parameter(name: "pageNumber", value: "no-cache")
        let parameter2 = QueryParameters.Parameter(name: "userId", value: "1313")
        let expectedQueryParameters = [ parameter1, parameter2]
        
        var actualQueryParameters = QueryParameters(parameters: [parameter1])
        
        // when
        actualQueryParameters.set(parameter2)
        
        // then
        for (index, Parameter) in expectedQueryParameters.enumerated() {
            XCTAssertEqual(actualQueryParameters.parameters[index], Parameter)
        }
    }
    
    func testSetByReplacingAllExisingParameters() {
        // given
        let parameter1 = QueryParameters.Parameter(name: "pageNumber", value: "1")
        let parameter2 = QueryParameters.Parameter(name: "pageNumber", value: "2")
        let expectedParameter = QueryParameters.Parameter(name: "pageNumber", value: "3")
        
        var actualQueryParameters = QueryParameters(parameters: [parameter1, parameter2])
        
        // when
        actualQueryParameters.set(expectedParameter)
        
        // then
        for actualParameter in actualQueryParameters.parameters {
            XCTAssertEqual(actualParameter, expectedParameter)
        }
    }
    
    func testRemoveParameter() {
        // given
        let parameter1 = QueryParameters.Parameter(name: "pageNumber", value: "1")
        let parameter2 =  QueryParameters.Parameter(name: "api_key", value: "1234-abcde-9876")
        let parameter3 = QueryParameters.Parameter(name: "pageNumber", value: "2")
        let parameter4 = QueryParameters.Parameter(name: "userId", value: "1313")
        let expectedQueryParameters = [parameter2, parameter4]
        var actualQueryParameters = QueryParameters(parameters: [parameter1, parameter2, parameter3, parameter4])

        // when
        actualQueryParameters.remove(name: "pageNumber")
        
        // then
        for (index, Parameter) in expectedQueryParameters.enumerated() {
            XCTAssertEqual(actualQueryParameters.parameters[index], Parameter)
        }
    }
}

// MARK: - Querying
extension QueryParametersTests {
    func testGetFirst() {
        // given
        let parameters = [
            QueryParameters.Parameter(name: "pageNumber", value: "1"),
            QueryParameters.Parameter(name: "pageNumber", value: "2")
        ]
        
        let actualQueryParameters = QueryParameters(parameters: parameters)
        
        // when
        let actualValue = actualQueryParameters.first(name: "pageNumber")
        
        // then
        XCTAssertEqual(actualValue, "1")
    }
    
    func testGetLast() {
        // given
        let parameters = [
            QueryParameters.Parameter(name: "pageNumber", value: "1"),
            QueryParameters.Parameter(name: "pageNumber", value: "2")
        ]
        
        let actualQueryParameters = QueryParameters(parameters: parameters)
        
        // when
        let actualResult = actualQueryParameters.last(name: "pageNumber")
        
        // then
        XCTAssertEqual(actualResult, "2")
    }
    
    func testGetAll() {
        // given
        let parameters = [
            QueryParameters.Parameter(name: "pageNumber", value: "1"),
            QueryParameters.Parameter(name: "pageNumber", value: "2")
        ]
        
        let actualQueryParameters = QueryParameters(parameters: parameters)
        
        // when
        let actualResult = actualQueryParameters.all(name: "pageNumber")
        
        // then
        XCTAssertEqual(actualResult, ["1", "2"])
    }
    
    func testGetAllNames() {
        // given
        let parameters = [
            QueryParameters.Parameter(name: "api_key", value: "1234-abcde-9876"),
            QueryParameters.Parameter(name: "userId", value: "1313")
        ]
        
        let actualQueryParameters = QueryParameters(parameters: parameters)
        
        // when
        let actualResult = actualQueryParameters.names
        
        // then
        XCTAssertEqual(actualResult, ["api_key", "userId"])
    }
    
    func testGetAllValues() {
        // given
        let parameters = [
            QueryParameters.Parameter(name: "api_key", value: "1234-abcde-9876"),
            QueryParameters.Parameter(name: "pageNumber", value: "1")
        ]
        
        let actualQueryParameters = QueryParameters(parameters: parameters)
        
        // when
        let actualResult = actualQueryParameters.values
        
        // then
        XCTAssertEqual(actualResult, ["1234-abcde-9876", "1"])
    }
}

// MARK: - Equatable
extension QueryParametersTests {
    func testEqual() {
        // given
        let parameter1 = QueryParameters.Parameter(name: "api_key", value: "1234-abcde-9876")
        let parameter2 = QueryParameters.Parameter(name: "pageNumber", value: "1")
        let parameter3 = QueryParameters.Parameter(name: "pageNumber", value: "2")
        
        let cases: [(lhs: QueryParameters, rhs: QueryParameters, expectedResult: Bool)] = [
            (lhs: QueryParameters(parameters: [parameter1, parameter2]), rhs: QueryParameters(parameters: [parameter1, parameter2]), expectedResult: true),
            (lhs: QueryParameters(parameters: [parameter1, parameter2]), rhs: QueryParameters(parameters: [parameter2, parameter1]), expectedResult: true),
            (lhs: QueryParameters(parameters: [parameter1, parameter2]), rhs: QueryParameters(parameters: [parameter1, parameter3]), expectedResult: false),
            (lhs: QueryParameters(parameters: [parameter2, parameter3]), rhs: QueryParameters(parameters: [parameter2]), expectedResult: false)
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
extension QueryParametersTests {
    func testDescription() {
        // given
        // when
        let actualQueryParameters = QueryParameters()
        // then
        XCTAssertFalse(actualQueryParameters.description.isEmpty)
    }
}
