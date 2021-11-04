//
//  URLRequestAdapter.swift
//  Jarvis
//
//  Created by Michal on 22/10/2020.
//

import Foundation

public protocol URLRequestAdapting {
    func map(request: Request, usingConfiguration configuration: HttpClient.Configuration) -> URLRequest?
}

public final class URLRequestAdapter: URLRequestAdapting {
    public func map(request: Request, usingConfiguration configuration: HttpClient.Configuration) -> URLRequest? {
        guard let url = urlFromRequest(request, configuration: configuration) else {
            return nil
        }

        var urlRequest = URLRequest(url: url, cachePolicy: configuration.cachePolicy, timeoutInterval: configuration.timeoutInterval)
        
        // Set headers
        request.headers.fields.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.name)
        }
        
        // Set HTTP method
        urlRequest.httpMethod = request.method.rawValue
        
        // Set body
        urlRequest.httpBody = request.body?.data

        if let mediaType = request.body?.mediaType, !request.headers.fields.contains(where: { $0.name == "Content-Type" }) {
            urlRequest.setValue(mediaType.value, forHTTPHeaderField: "Content-Type")
        }
        
        // Set other options
        urlRequest.allowsCellularAccess = configuration.isCellularAccessAllowed
        
        return urlRequest
    }
}

private extension URLRequestAdapter {
    func urlFromRequest(_ request: Request, configuration: HttpClient.Configuration) -> URL? {
        switch request.target {
        case .url(let httpUrl): return httpUrl.fullUrl
        case .endpoint(let endpoint): return configuration.baseUrl?.fullUrl?.appendingPathComponent(endpoint)
        case .none: return nil
        }
    }
}
