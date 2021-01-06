//
//  NetworkTaskRepository.swift
//  Jarvis
//
//  Created by Michal on 26/10/2020.
//

import Foundation

internal struct NetworkTaskRepository {
    internal var tasks: [NetworkTask] = []
    
    public var count: Int {
        return tasks.count
    }
}

// MARK: - Items Manipulation
internal extension NetworkTaskRepository {
    mutating func add(_ newTask: NetworkTask) {
        tasks.append(newTask)
    }
    
    mutating func removeAll() {
        tasks.removeAll()
    }
    
    mutating func remove(at index: Int) {
        guard 0..<tasks.count ~= index else {
            return
        }
        
        tasks.remove(at: index)
    }
    
    mutating func remove(_ task: NetworkTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            remove(at: index)
        }
    }
}

// MARK: - Subscripts
internal extension NetworkTaskRepository {
    subscript(index: Int) -> NetworkTask {
        return tasks[index]
    }
    
    subscript(task: URLSessionTask) -> NetworkTask? {
        return tasks.first(where: { $0.task == task })
    }
}

// MARK: - Collection
extension NetworkTaskRepository: Collection {
    public var startIndex: Int {
        return tasks.startIndex
    }
    
    public var endIndex: Int {
        return tasks.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return tasks.index(after: i)
    }
}
