//
//  HttpClientTests.swift
//  Jarvis
//
//  Created by Michal on 22/10/2020.
//

import XCTest
@testable import Jarvis

final class HttpClientTests: XCTestCase {
}

// MARK: - Initialization & properties
extension HttpClientTests {
    func testDefaultInit() {
        // given
        // when
        let client = HttpClient()
        
        // then
        XCTAssertEqual(client.configuration, HttpClient.Configuration.default)
    }
    
    func testDeinitFinishesActiveTasks() {
        // given
        let taskStatusExpectation = expectation(description: "Task should finished")
        
        var configuration = HttpClient.Configuration.default
        configuration.automaticallyStartRequest = true
        
        var client: HttpClient? = HttpClient()
            .configuration(configuration)
            
        let request = Request()
            .url("https://httpbin.org/get")
            .method(.get)
                
        let actualTask = client?.send(request, callback: {_ in })
        
        // when
        DispatchQueue.global(qos: .userInitiated).async {
            client = nil
            
            if actualTask?.state == .completed {
                taskStatusExpectation.fulfill()
            }
        }
        
        // then
        waitForExpectations(timeout: 10)
    }
}

// MARK: - Builder
extension HttpClientTests {
    func testSetConfiguration() {
        // given
        let baseUrl = HttpUrl("https://httpbin.org")
        let expectedConfig = HttpClient.Configuration(baseUrl: baseUrl)
        
        // when
        let client = HttpClient()
            .configuration(expectedConfig)
        
        // then
        XCTAssertEqual(client.configuration, expectedConfig)
    }
    
    func testSetBaseUrl() {
        // given
        let expectedBaseUrl = HttpUrl("https://httpbin.org")
        
        // when
        let client = HttpClient()
            .baseUrl(expectedBaseUrl)
        
        // then
        XCTAssertEqual(client.configuration.baseUrl, expectedBaseUrl)
    }
}

// MARK: - Sending Http Request
extension HttpClientTests {
    func testSendReturnFetchTask() {
        // given
        let client = HttpClient()
            
        let request = Request()
            .url("https://httpbin.org/get")
            .method(.get)
        
        // when
        let actualTask = client.send(request, callback: {_ in })
        
        // then
        XCTAssertTrue(actualTask.completionHandlers.count > 0)
        XCTAssertNotEqual(actualTask.state, .cancelled)
    }
    
    func testSendAutomaticallyStartRequest() {
        // given
        var configuration = HttpClient.Configuration.default
        configuration.automaticallyStartRequest = true
        
        let client = HttpClient()
            .configuration(configuration)
            
        let request = Request()
            .url("https://httpbin.org/get")
            .method(.get)
        
        // when
        let actualTask = client.send(request, callback: {_ in })
        
        // then
        XCTAssertTrue(actualTask.completionHandlers.count > 0)
        XCTAssertNotEqual(actualTask.state, .initialized)
    }
    
    func testSendDoesNotAutomaticallyStartRequest() {
        // given
        var configuration = HttpClient.Configuration.default
        configuration.automaticallyStartRequest = false
        
        let client = HttpClient()
            .configuration(configuration)
            
        let request = Request()
            .url("https://httpbin.org/get")
            .method(.get)
        
        // when
        let actualTask = client.send(request, callback: {_ in })
        
        // then
        XCTAssertTrue(actualTask.completionHandlers.count > 0)
        XCTAssertEqual(actualTask.state, .initialized)
    }
    
    func testSendAddTaskToListOfActiveTasks() {
        // given
        let client = HttpClient()
        let isEmpty = client.activeTasks.count ==  0
        XCTAssertTrue(isEmpty)

        let request = Request()
            .url("https://httpbin.org/get")
            .method(.get)
        
        // when
        let actualTask = client.send(request, callback: {_ in })
        
        // then
        let containsTask = client.activeTasks.contains(where: { $0.id == actualTask.id })
        XCTAssertTrue(containsTask)
    }
}

// MARK: - Download Request
extension HttpClientTests {
    func testDownloadReturnDownloadTask() {
        // given
        let client = HttpClient()
        let request = Request(url: "https://httpbin.org/get")
        
        // when
        let actualTask = client.download(request)
        
        // then
        XCTAssertNotEqual(actualTask.state, .cancelled)
    }
    
    func testDownloadAutomaticallyStartRequest() {
        // given
        var configuration = HttpClient.Configuration.default
        configuration.automaticallyStartRequest = true
        
        // given
        let client = HttpClient()
            .configuration(configuration)
        
        let request = Request(url: "https://httpbin.org/get")
        
        // when
        let actualTask = client.download(request)
        
        // then
        XCTAssertNotEqual(actualTask.state, .initialized)
    }
    
    func testDownloadDoesNotAutomaticallyStartRequest() {
        // given
        var configuration = HttpClient.Configuration.default
        configuration.automaticallyStartRequest = false
        
        let client = HttpClient()
            .configuration(configuration)
        
        let request = Request(url: "https://httpbin.org/get")
        
        // when
        let actualTask = client.download(request)
        
        // then
        XCTAssertEqual(actualTask.state, .initialized)
    }
    
    func testDownloadAddTaskToListOfActiveTasks() {
        // given
        let client = HttpClient()
        let isEmpty = client.activeTasks.count ==  0
        XCTAssertTrue(isEmpty)

        let request = Request(url: "https://httpbin.org/get")
        
        // when
        let actualTask = client.download(request)

        // then
        let containsTask = client.activeTasks.contains(where: { $0.id == actualTask.id })
        XCTAssertTrue(containsTask)
    }
}

// MARK: - Upload Request
extension HttpClientTests {
    func testUploadReturnUploadTask() {
        // given
        let client = HttpClient()
        let request = Request(url: "https://httpbin.org/post")
            .body(BodyContent(string: "Hello world"))
        
        // when
        let actualTask = client.upload(request)
        
        // then
        XCTAssertNotEqual(actualTask.state, .cancelled)
    }
    
    func testUploadAutomaticallyStartRequest() {
        // given
        var configuration = HttpClient.Configuration.default
        configuration.automaticallyStartRequest = true
        
        // given
        let client = HttpClient()
            .configuration(configuration)
        
        let request = Request(url: "https://httpbin.org/post")
            .body(BodyContent(string: "Hello world"))
        
        // when
        let actualTask = client.upload(request)
        
        // then
        XCTAssertNotEqual(actualTask.state, .initialized)
    }
    
    func testUploadDoesNotAutomaticallyStartRequest() {
        // given
        var configuration = HttpClient.Configuration.default
        configuration.automaticallyStartRequest = false
        
        let client = HttpClient()
            .configuration(configuration)
        
        let request = Request(url: "https://httpbin.org/post")
            .body(BodyContent(string: "Hello world"))
        
        // when
        let actualTask = client.upload(request)
        
        // then
        XCTAssertEqual(actualTask.state, .initialized)
    }
    
    func testUploadAddTaskToListOfActiveTasks() {
        // given
        let client = HttpClient()
        let isEmpty = client.activeTasks.count ==  0
        XCTAssertTrue(isEmpty)

        let request = Request(url: "https://httpbin.org/post")
            .body(BodyContent(string: "Hello world"))
        
        // when
        let actualTask = client.upload(request)

        // then
        let containsTask = client.activeTasks.contains(where: { $0.id == actualTask.id })
        XCTAssertTrue(containsTask)
    }
}

/*
extension HttpClientTests {
    func testSendPublisher() {
        // given
        let taskStatusExpectation = expectation(description: "Task should finished")

        let client = HttpClient()
            
        let request = Request()
            .url(string: "https://httpbin.org/get")
            .method(.get)
                
        let cancellable = client.send(request)
            .publisher()
            .map({ $0.body?.string() })
            .sink(receiveCompletion: {
                error in print(error)
                
            }, receiveValue: {
                body in print(body)
            })
        
        // then
        waitForExpectations(timeout: 10)
    }
}
*/
