//
//  FileBody.swift
//  Jarvis
//
//  Created by Michal on 09/11/2020.
//

import Foundation

public struct FileBody: BodyContentRepresentable {
    public let fileUrl: URL
    
    public var data: Data? {
        return try? Data(contentsOf: fileUrl)
    }
    
    public var mediaType: MediaType?
    
    public init(fileUrl: URL, mediaType: MediaTypeConvertible? = nil) {
        self.fileUrl = fileUrl
        self.mediaType = mediaType?.asMediaType()
    }
}
