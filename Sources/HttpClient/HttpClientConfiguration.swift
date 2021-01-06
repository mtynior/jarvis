//
//  File.swift
//  Jarvis
//
//  Created by Michal on 22/10/2020.
//

import Foundation

public typealias CachePolicy = URLRequest.CachePolicy

public extension HttpClient {
    struct Configuration: Equatable {
        public var baseUrl: HttpUrl?
        public var timeoutInterval: TimeInterval
        public var cachePolicy: CachePolicy
        public var isCellularAccessAllowed: Bool
        public var automaticallyStartRequest: Bool
        
        public static let `default` = Configuration()
        
        public init(
            baseUrl: HttpUrl? = nil,
            timeoutInterval: TimeInterval = 30.0,
            cachePolicy: CachePolicy = .reloadIgnoringLocalCacheData,
            isCellularAccessAllowed: Bool = true,
            automaticallyStartRequest: Bool = true
        ) {
            self.baseUrl = baseUrl
            self.timeoutInterval = timeoutInterval
            self.cachePolicy = cachePolicy
            self.isCellularAccessAllowed = isCellularAccessAllowed
            self.automaticallyStartRequest = automaticallyStartRequest
        }
    }
}
