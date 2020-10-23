//
//  BodyContent+Json.swift
//  Jarvis
//
//  Created by Michal on 15/11/2020.
//

import Foundation

public extension BodyContent {
    init<T: Encodable>(json: T, mediaType: MediaType = "application/json".asMediaType(), jsonEncoder: JSONEncoder = JSONEncoder()) throws {
        self.data = try jsonEncoder.encode(json)
        self.mediaType = mediaType
    }
    
    func json<T: Decodable>(decoder: JSONDecoder = .init()) throws -> T? {
        guard let data = data else {
            return nil
        }
        
        return try decoder.decode(T.self, from: data)
    }
}
