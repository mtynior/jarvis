//
//  HttpRequestTarget.swift
//  Jarvis
//
//  Created by Michal on 11/10/2020.
//

import Foundation

public enum HttpRequestTarget: Equatable {
    case url(HttpUrl)
    case endpoint(String)
    
    var path: String {
        switch self {
        case .url(let url): return url.fullUrl?.absoluteString ?? ""
        case .endpoint(let endpoint): return endpoint
        }
    }
}

// MARK: - CustomStringConvertible
extension HttpRequestTarget: CustomStringConvertible {
    public var description: String {
        return path
    }
}
