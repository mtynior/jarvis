//
//  DataResponse.swift
//  Jarvis
//
//  Created by Michal on 11/10/2020.
//

import Foundation

public struct DataResponse {
    public internal(set) var request: Request?
    public internal(set) var statusCode: Int
    public internal(set) var statusMessage: String?
    public internal(set) var headers: HttpHeaders
    public internal(set) var body: BodyContent?

    public var isSuccess: Bool {
        return 200...299 ~= statusCode
    }
    
    public var isRedirection: Bool {
        return 300...399 ~= statusCode
    }
    
    public init(request: Request? = nil, statusCode: Int = -1, statusMessage: String? = nil, headers: HttpHeaders = .init(), body: BodyContent? = nil) {
        self.request = request
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.headers = headers
        self.body = body
    }
}

// MARK: - CustomStringConvertible
extension DataResponse: CustomStringConvertible {
    public var description: String {
        return DescriptionBuilder()
            .addLine(request?.description, placeholder: "None")
            .addLine("[Response]")
            .addLine("[Status Code]", indentation: 1)
            .addLine("\(statusCode)", indentation: 2)
            .addLine("[Headers]", indentation: 1)
            .addLine(headers.description, indentation: 2)
            .addLine("[Body]", indentation: 1)
            .addLine(body?.description, placeholder: "None", indentation: 2)
            .description
    }
}
