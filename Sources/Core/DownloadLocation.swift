//
//  DownloadLocation.swift
//  Jarvis
//
//  Created by Michal on 06/11/2020.
//

import Foundation

public struct DownloadLocation {
    public var locationUrl: URL?
    public var fileName: FileName
    public var options: SaveOptions
    
    public static var suggestedDownloadLocation: URL? {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    public static var `default` = DownloadLocation()
    
    public init(locationUrl: URL? = Self.suggestedDownloadLocation, fileName: FileName = .original, options: SaveOptions = [.createIntermediateDirectories, .replaceExistingFile]) {
        self.locationUrl = locationUrl
        self.fileName = fileName
        self.options = options
    }
}

public extension DownloadLocation {
    enum FileName: Equatable {
        case original
        case renamed(String)
    }
    
    struct SaveOptions: OptionSet {
        public static let createIntermediateDirectories = SaveOptions(rawValue: 1 << 0)
        public static let replaceExistingFile = SaveOptions(rawValue: 1 << 1)
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
