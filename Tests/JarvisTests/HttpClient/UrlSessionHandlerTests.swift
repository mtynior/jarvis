//
//  UrlSessionHandlerTests.swift
//  Jarvis
//
//  Created by Michal on 27/10/2020.
//

import XCTest
@testable import Jarvis

final class UrlSessionHandlerTests: XCTestCase {
    static var allTests = [
        // URLSessionDataDelegate
        ("testDidReceiveData", testDidReceiveData),
        ("testDidCompleteWithError", testDidCompleteWithError)
    ]
    
    var httpClient: HttpClient?
    
    override func setUp() {
        super.setUp()
        httpClient = HttpClient()
    }
    
    override func tearDown() {
        super.tearDown()
        httpClient = nil
    }
}

// MARK: - URLSessionDataDelegate
extension UrlSessionHandlerTests {
    func testDidReceiveData() {
        // given
        let callExpectation = expectation(description: "Should call task's method")
        
        let fakeTask = FakeNetworkTask()
        httpClient?.activeTasks.add(fakeTask)
        
        fakeTask.onDidReceiveData = { _ in
            callExpectation.fulfill()
        }
        
        // when
        httpClient?.urlSessionHandler.urlSession(fakeTask.session, dataTask: fakeTask.task as! URLSessionDataTask, didReceive: Data())
        
        // then
        waitForExpectations(timeout: 10)
    }
    
    func testDidCompleteWithError() {
        // given
        let callExpectation = expectation(description: "Should call task's method")
        
        let fakeTask = FakeNetworkTask()
        httpClient?.activeTasks.add(fakeTask)
        
        fakeTask.onCompleteWithError = { _ in
            callExpectation.fulfill()
        }
        
        // when
        httpClient?.urlSessionHandler.urlSession(fakeTask.session, task: fakeTask.task!, didCompleteWithError: nil)
        
        // then
        waitForExpectations(timeout: 10)
    }
}

final class FakeNetworkTask: DataFetchingTask {
    var id: UUID = UUID()
    var request: Request = Request()
    var state: NetworkTaskState = .initialized
 
    let session = URLSession.shared
    lazy var task: URLSessionTask? =  {
        session.dataTask(with: URLRequest(url: URL(string: "https://httpbin.org/get")!))
    }()
    
    var onDidReceiveData: ((Data) -> Void)?
    var onCompleteWithError: ((Error?) -> Void)?
    
    func resume() {}
    func cancel() {}
    func suspend() {}
    
    func didReceiveData(_ data: Data) {
        onDidReceiveData?(data)
    }
    
    func addCompletion(_ handler: @escaping (Result<DataResponse, Error>) -> Void) -> Self {
        return self
    }
    
    func completeWith(error: Error?) {
        if state != .completed {
            onCompleteWithError?(error)
            state = .completed
        }
    }
}
