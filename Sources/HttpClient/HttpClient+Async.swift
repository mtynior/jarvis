//
//  HttpClient+Async.swift
//  Jarvis
//
//  Created by Michal on 03/11/2020.
//

import Foundation

@available(macOS 12.0.0, iOS 15, watchOS 8, tvOS 15, *)
public extension HttpClient {
    func send(_ request: Request) async throws -> DataResponse {
        try await withCheckedThrowingContinuation { continuation in
            send(request) { result in
                switch result {
                case .success(let dataResponse):
                    continuation.resume(returning: dataResponse)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            .resume()
        }
    }
    
    func download(_ request: Request, downloadLocation: DownloadLocation = .default) async throws -> DownloadResponse {
        try await withCheckedThrowingContinuation { continuation in
            download(request, downloadLocation: downloadLocation) { result in
                switch result {
                case .success(let downloadResponse):
                    continuation.resume(returning: downloadResponse)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            .resume()
        }
    }
    
    func upload(_ request: Request) async throws -> DataResponse {
        try await withCheckedThrowingContinuation { continuation in
            upload(request) { result in
                switch result {
                case .success(let uploadResponse):
                    continuation.resume(returning: uploadResponse)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            .resume()
        }
    }
}
