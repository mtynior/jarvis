//
//  HttpMethod.swift
//  Jarvis
//
//  Created by Michal on 11/10/2020.
//

import Foundation

public enum HttpMethod: String, Equatable {
    case option = "OPTION"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

// MARK: - CustomStringConvertible
extension HttpMethod: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
