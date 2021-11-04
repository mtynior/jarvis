//
//  NetworkTaskRepositoryTests.swift
//  Jarvis
//
//  Created by Michal on 27/10/2020.
//

import XCTest
@testable import Jarvis

final class NetworkTaskRepositoryTests: XCTestCase {
}

// MARK: - // Initialization & properties
extension NetworkTaskRepositoryTests {
    func testDefaultInit() {
        // given
        // when
        let repository = NetworkTaskRepository()
        
        // then
        XCTAssertTrue(repository.tasks.isEmpty)
    }
    
    func testCount() {
        // given
        let task = makeTask()
        var repository = NetworkTaskRepository()

        // when
        repository.tasks.append(task)
        
        // then
        XCTAssertEqual(repository.count, repository.tasks.count)
    }
}

// MARK: - Items Manipulation
extension NetworkTaskRepositoryTests {
    func testAdd() {
        // given
        let task = makeTask()
        var repository = NetworkTaskRepository()

        // when
        repository.add(task)
        
        // then
        let containsTask = repository.tasks.contains(where: { $0.id == task.id })
        XCTAssertTrue(containsTask)
    }
    
    func testRemove() {
        // given
        let task = makeTask()
        
        var repository = NetworkTaskRepository()
        repository.tasks.append(task)
        
        // when
        repository.remove(task)
        
        // then
        let containsTask = repository.tasks.contains(where: { $0.id == task.id })
        XCTAssertFalse(containsTask)
    }
    
    func testRemoveAt() {
        // given
        let task = makeTask()
        
        var repository = NetworkTaskRepository()
        repository.tasks.append(task)
        
        // when
        repository.remove(at: 0)
        
        // then
        let containsTask = repository.tasks.contains(where: { $0.id == task.id })
        XCTAssertFalse(containsTask)
    }
    
    func testRemoveAtOutOfBounds() {
        // given
        let task = makeTask()
        
        var repository = NetworkTaskRepository()
        repository.tasks.append(task)
        
        // when
        repository.remove(at: 10)
        
        // then
        let containsTask = repository.tasks.contains(where: { $0.id == task.id })
        XCTAssertTrue(containsTask)
    }
    
    func testRemoveAll() {
        // given
        let task = makeTask()
        
        var repository = NetworkTaskRepository()
        repository.tasks.append(task)
        
        // when
        repository.removeAll()
        
        // then
        XCTAssertTrue(repository.isEmpty)
    }
}

// MARK: - Subsripts
extension NetworkTaskRepositoryTests {
    func testIndexSubsript() {
        // given
        let expectedTask = makeTask()
        
        var repository = NetworkTaskRepository()
        repository.tasks.append(expectedTask)
        
        // when
        let actualTask = repository[0]
        
        // then
        XCTAssertEqual(actualTask.id, expectedTask.id)
    }
    
    func testSessionTaskSubsript() {
        // given
        let expectedTask = makeTask()
        
        var repository = NetworkTaskRepository()
        repository.tasks.append(expectedTask)
        
        // when
        let actualTask = repository[expectedTask.task!]
        
        // then
        XCTAssertEqual(actualTask?.id, expectedTask.id)
    }
}

// MARK: - Helper
private extension NetworkTaskRepositoryTests {
    func makeTask() -> FetchDataTask {
        let request = Request().url("https://httpbin.org/get")
        let client = HttpClient()
        let delegate = FakeTaskDelegate()
        
        return FetchDataTask(request: request, httpClient: client, delegate: delegate)
    }

    class FakeTaskDelegate: NetworkTaskDelegate {
        func dataTaskFor(urlRequest: URLRequest) -> URLSessionDataTask? {
            return URLSession.shared.dataTask(with: urlRequest)
        }
    }
}
