//
//  Request.swift
//  Jarvis
//
//  Created by Michal on 11/10/2020.
//

import Foundation

public struct Request {
    public let id: UUID = UUID()
    private(set) var target: HttpRequestTarget?
    private(set) var method: HttpMethod = .get
    private(set) var body: BodyContentRepresentable?
    private(set) var headers: HttpHeaders = HttpHeaders()
 
    public init() { }
    
    public init(url: HttpUrlConvertible) {
        self.target = .url(url.asHttpUrl())
    }
    
    public init(url: HttpUrlConvertible, method: HttpMethod) {
        self.target = .url(url.asHttpUrl())
        self.method = method
    }
}

// MARK: - URLs
public extension Request {
    func url(_ url: HttpUrlConvertible) -> Self {
        var copy = self
        copy.target = .url(url.asHttpUrl())
        return copy
    }
    
    func endpoint(_ endpoint: String) -> Self {
        var copy = self
        copy.target = .endpoint(endpoint)
        return copy
    }
}

// MARK: - Http Methods
public extension Request {
    func method(_ method: HttpMethod) -> Self {
        var copy = self
        copy.method = method
        return copy
    }
    
    func option() -> Self {
        var copy = self
        copy.method = .option
        return copy
    }
    
    func get() -> Self {
        var copy = self
        copy.method = .get
        return copy
    }
    
    func head() -> Self {
        var copy = self
        copy.method = .head
        return copy
    }
    
    func post(_ body: BodyContentRepresentable? = nil) -> Self {
        var copy = self
        copy.method = .post
        copy.body = body
        return copy
    }
    
    func put(_ body: BodyContentRepresentable? = nil) -> Self {
        var copy = self
        copy.method = .put
        copy.body = body
        return copy
    }
    
    func patch(_ body: BodyContentRepresentable? = nil) -> Self {
        var copy = self
        copy.method = .patch
        copy.body = body
        return copy
    }
    
    func delete(_ body: BodyContentRepresentable? = nil) -> Self {
        var copy = self
        copy.method = .delete
        copy.body = body
        return copy
    }
    
    func trace() -> Self {
        var copy = self
        copy.method = .trace
        return copy
    }
    
    func connect() -> Self {
        var copy = self
        copy.method = .connect
        return copy
    }
}

// MARK: - Header
public extension Request {
    func addHeader(name: String, value: String) -> Self {
        var copy = self
        copy.headers.add(HttpHeaders.Field(name: name, value: value))
        return copy
    }
    
    func addHeaders(_ headers: HttpHeaders) -> Self {
        var copy = self
        copy.headers.add(headers: headers)
        return copy
    }
    
    func setHeader(name: String, value: String) -> Self {
        var copy = self
        copy.headers.set(HttpHeaders.Field(name: name, value: value))
        return copy
    }
    
    func removeHeader(name: String) -> Self {
        var copy = self
        copy.headers.remove(name: name)
        return copy
    }
}

// MARK: - Body
public extension Request {
    func body(_ body: BodyContentRepresentable?) -> Self {
        var copy = self
        copy.body = body
        return copy
    }
}

// MARK: - CustomStringConvertible
extension Request: CustomStringConvertible {
    public var description: String {
        let targetDescription = target?.description ?? ""
        let requestDescription = "\(method) \(targetDescription)"
        let bodyDescription = (body as? CustomStringConvertible)?.description
        
        return DescriptionBuilder("[Request]")
            .addLine(requestDescription, indentation: 1)
            .addLine("[Headers]", indentation: 1)
            .addLine(headers.description, indentation: 2)
            .addLine("[Body]", indentation: 1)
            .addLine(bodyDescription, placeholder: "None", indentation: 2)
            .description
    }
}
