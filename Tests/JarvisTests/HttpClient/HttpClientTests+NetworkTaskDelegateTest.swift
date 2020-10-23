//
//  HttpClientTests+NetworkTaskDelegate.swift
//  Jarvis
//
//  Created by Michal on 27/10/2020.
//

import XCTest
@testable import Jarvis

final class HttpClientTests_NetworkTaskDelegate: XCTestCase {
    static var allTests = [
        ("testTaskFinishedWithResultRemovesTaskFromListOfActiveTasks", testTaskFinishedWithResultRemovesTaskFromListOfActiveTasks),
        ("testDataTaskFor", testDataTaskFor)
    ]
    
    func testTaskFinishedWithResultRemovesTaskFromListOfActiveTasks() {
        // given
        let client = HttpClient()
        
        let request = Request()
            .url("https://httpbin.org/get")
            .method(.get)
        
        let actualTask = client.send(request, callback: {_ in })
        XCTAssertFalse(client.activeTasks.isEmpty)
        
        // when
        client.didFinishTask(actualTask)
        
        // then
        XCTAssertTrue(client.activeTasks.isEmpty)
    }
    
    func testDataTaskFor() {
        // given
        let urlRequest = URLRequest(url: URL(string: "https://httpbin.org/get")!)
        let client = HttpClient()
        
        // when
        let sessionDataTask = client.dataTaskFor(urlRequest: urlRequest)
        
        // then
        XCTAssertNotNil(sessionDataTask)
    }
}
