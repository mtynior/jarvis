//
//  BodyContent.swift
//  Jarvis
//
//  Created by Michal on 15/11/2020.
//

import Foundation

public protocol BodyContentRepresentable {
    var data: Data? { get }
    var mediaType: MediaType? { get }
}

public struct BodyContent: BodyContentRepresentable {
    public var data: Data?
    public var mediaType: MediaType?

    public init() {
        self.init(data: nil, mediaType: nil)
    }
    
    public init(data: Data?, mediaType: MediaTypeConvertible? = nil) {
        self.data = data
        self.mediaType = mediaType?.asMediaType()
    }
}

// MARK: - CustomStringConvertible
extension BodyContent: CustomStringConvertible {
    public var description: String {
        return """
        MediaType: \(mediaType?.description ?? "Unknown")
        Bytes: \(data?.count ?? 0)
        """
    }
}
