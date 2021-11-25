//
//  URLResponseMapper.swift
//  Jarvis
//
//  Created by Michal on 23/10/2020.
//

import Foundation

public protocol URLResponseAdapting {
    func map(httpUrlResponse: HTTPURLResponse, data: Data?, for request: Request) -> DataResponse?
}

public final class URLResponseAdapter: URLResponseAdapting {
    public func map(httpUrlResponse: HTTPURLResponse, data: Data?, for request: Request) -> DataResponse? {
        //
        let statusCode = httpUrlResponse.statusCode
        let statusMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
        
        // Headers
        let fieldsArray = httpUrlResponse.allHeaderFields.map({ (key, value) in
            return ("\(key)", "\(value)")
        })
        
        let headers = HttpHeaders(dictionary: Dictionary(uniqueKeysWithValues: fieldsArray))
        
        // Body
        let contentType = headers.fields.first(where: { $0.name == "Content-Type" })?.value
        let body = data != nil ? BodyContent(data: data!, mediaType: contentType) : nil
        
        return DataResponse(request: request, statusCode: statusCode, statusMessage: statusMessage, headers: headers, body: body)
    }
}
