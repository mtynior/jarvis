//
//  File.swift
//  Jarvis
//
//  Created by Michal on 11/10/2020.
//

import Foundation

public struct HttpUrl {
    public internal(set) var urlComponents: URLComponents?
    
    public var scheme: String? {
        return urlComponents?.scheme
    }
    
    public var host: String? {
        return urlComponents?.host
    }
    
    public var port: Int? {
        return urlComponents?.port
    }
    
    public var fullUrl: URL? {
        return urlComponents?.url
    }
    
    public init() {
        self.urlComponents = URLComponents()
    }
    
    public init(_ string: String) {
        self.urlComponents = URLComponents(string: string)
    }
    
    public init(_ url: URL) {
        self.urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    }
}

// MARK: - Builder
public extension HttpUrl {
    func scheme(_ scheme: String) -> Self {
        var copy = self
        copy.urlComponents?.scheme = scheme
        return copy
    }
    
    func host(_ host: String) -> Self {
        var copy = self
        copy.urlComponents?.host = host
        return copy
    }
    
    func port(_ port: Int) -> Self {
        var copy = self
        copy.urlComponents?.port = max(1, min(port, 65535))
        return copy
    }
}

// MARK: - Equatable
extension HttpUrl: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        let isSameScheme = lhs.urlComponents?.scheme?.lowercased() == rhs.urlComponents?.scheme?.lowercased()
        let isSameHost = lhs.urlComponents?.host?.lowercased() == rhs.urlComponents?.host?.lowercased()
        let isSamePath = lhs.urlComponents?.path.lowercased().removingSuffix("/") == rhs.urlComponents?.path.lowercased().removingSuffix("/")
        
        let isSamePort: Bool = {
            switch (lhs.port, lhs.scheme?.lowercased(), rhs.port, rhs.scheme?.lowercased()) {
            case (nil, nil, nil, nil): return true
            case (nil, "http", nil, "http"): return true
            case(nil, "http", 80, "http"): return true
            case(80, "http", nil, "http"): return true
            case(nil, "https", nil, "https"): return true
            case(nil, "https", 443, "https"): return true
            case(443, "https", nil, "https"): return true
            default: return false
            }
        }()

        return isSameScheme && isSameHost && isSamePort && isSamePath
    }
}

// MARK: - CustomStringConvertible
extension HttpUrl: CustomStringConvertible {
    public var description: String {
        return fullUrl?.absoluteString ?? ""
    }
}

// MARK: - HTTPUrlConvertible
public protocol HttpUrlConvertible {
    func asHttpUrl() -> HttpUrl
}

extension HttpUrl: HttpUrlConvertible {
    public func asHttpUrl() -> HttpUrl {
        return self
    }
}

extension URL: HttpUrlConvertible {
    public func asHttpUrl() -> HttpUrl {
        return HttpUrl(self)
    }
}

extension String: HttpUrlConvertible {
    public func asHttpUrl() -> HttpUrl {
        return HttpUrl(self)
    }
}
