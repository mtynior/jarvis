//
//  Error.swift
//  Jarvis
//
//  Created by Michal on 26/10/2020.
//

import Foundation

public enum HttpClientError: Error, Equatable {
    case clientDeinitialized
    case unknown
}

public enum NetworkTaksError: Error, Equatable {
    case urlSessionTaskCreationFailed
    case responseSerializationFailed
    case emptyRequestBody
    case cancelled
    case unknown
}

public enum DownloadTaskError: Error, Equatable {
    case downloadedFileURLNotFound
    case downloadedFileMoveFailed
}
