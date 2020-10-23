//
//  BodyContent+Text.swift
//  Jarvis
//
//  Created by Michal on 15/11/2020.
//

import Foundation

public extension BodyContent {
    init(string: String, encoding: String.Encoding = .utf8, mediaType: MediaType = "text/plain".asMediaType()) {
        self.data = string.data(using: encoding)
        self.mediaType = mediaType
    }
    
    func string(encoding: String.Encoding = .utf8) -> String? {
        guard let data = self.data else {
            return nil
        }
        
        return String(data: data, encoding: encoding)
    }
}
