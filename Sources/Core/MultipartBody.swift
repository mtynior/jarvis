//
//  MultipartBody.swift
//  Jarvis
//
//  Created by Michal on 06/11/2020.
//

import Foundation

extension Data {
    public mutating func append(_ newElement: String, encoding: String.Encoding = .utf8) {
        guard let data = newElement.data(using: encoding) else {
            return
        }
        
        self.append(data)
    }
}

public struct MultipartBody: BodyContentRepresentable {
    public let boundary: String
    public private(set) var parts: [Part] = []
    
    public var data: Data? {
        var data = Data()
        
        for part in parts {
            data.append("--\(boundary)\r\n")
            for field in (part.headers?.fields ?? []) {
                let header = "\(field.name): \(field.value)\r\n"
                data.append(header)
            }
            data.append("\r\n")
            if let body = part.body.data {
                data.append(body)
                data.append("\r\n")
            }
        }
        
        data.append("--\(boundary)\r\n")

        return data
    }
    
    public var mediaType: MediaType? {
        return MediaType("multipart/form-data; boundary=\(boundary)")
    }
    
    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
    }
}

public extension MultipartBody {
    func addPart(_ part: Part) -> Self {
        var copy = self
        copy.parts.append(part)
        return copy
    }
    
    func addPart(body: BodyContentRepresentable) -> Self {
        let part = Part(headers: nil, body: body)

        var copy = self
        copy.parts.append(part)
        return copy
    }
    
    func addPart(headers: HttpHeaders?, body: BodyContentRepresentable) -> Self {
        let part = Part(headers: headers, body: body)

        var copy = self
        copy.parts.append(part)
        return copy
    }
    
    func addDataPart(name: String, value: String) -> Self {
        let part = Part(name: name, value: value)

        var copy = self
        copy.parts.append(part)
        return copy
    }
    
    func addDataPart(name: String, body: BodyContentRepresentable) -> Self {
        return addDataPart(name: name, filename: nil, body: body)
    }
    
    func addDataPart(name: String, filename: String?, body: BodyContentRepresentable) -> Self {
        let part = Part(name: name, filename: filename, body: body)

        var copy = self
        copy.parts.append(part)
        return copy
    }
}

public extension MultipartBody {
    struct Part {
        let headers: HttpHeaders?
        let body: BodyContentRepresentable
        
        init(headers: HttpHeaders?, body: BodyContentRepresentable) {
            self.headers = headers
            self.body = body
        }
        
        init(name: String, value: String) {
            self.init(name: name, filename: nil, body: BodyContent(string: value))
        }
        
        init(name: String, filename: String?, body: BodyContentRepresentable) {
            var disposition = "form-data; name=\"\(name)\""
            
            if let filename = filename {
                disposition += "; filename=\"\(filename)\""
            }
            
            let dispositionHeader = HttpHeaders.Field(name: "Content-Disposition", value: disposition)
            
            self.headers = HttpHeaders(fields: [dispositionHeader])
            self.body = body
        }
    }
}
