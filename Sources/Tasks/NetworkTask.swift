//
//  NetworkTask.swift
//  Jarvis
//
//  Created by Michal on 26/10/2020.
//

import Foundation

public protocol NetworkTask: class {
    var id: UUID { get }
    var request: Request { get }
    var task: URLSessionTask? { get }
    var state: NetworkTaskState { get }
    
    func resume()
    func cancel()
    func suspend()
}

protocol NetworkTaskCompletable {
    func completeWith(error: Error?)
}
