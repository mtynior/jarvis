//
//  MediaType.swift
//  Jarvis
//
//  Created by Michal on 15/11/2020.
//

import Foundation

public struct MediaType {
    let value: String
    
    var type: String? {
        guard let typeCharacters = value.split(separator: "/").first else {
            return nil
        }
        return String(typeCharacters)
    }
    
    var subtype: String? {
        guard let typeCharacters = value.split(separator: "/").last else {
            return nil
        }
        return String(typeCharacters)
    }
    
    public init(_ value: String) {
        self.value = value
    }
}

// MARK: - Equatable
extension MediaType: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value.lowercased() == rhs.value.lowercased()
    }
}

// MARK: - CustomStringConvertible
extension MediaType: CustomStringConvertible {
    public var description: String {
        return value
    }
}

// MARK: - MediaTypeConvertible
public protocol MediaTypeConvertible {
    func asMediaType() -> MediaType
}

extension MediaType: MediaTypeConvertible {
    public func asMediaType() -> MediaType {
        return self
    }
}

extension String: MediaTypeConvertible {
    public func asMediaType() -> MediaType {
        return MediaType(self)
    }
}
