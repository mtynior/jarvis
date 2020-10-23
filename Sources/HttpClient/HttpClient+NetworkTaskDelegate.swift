//
//  HttpClient+NetworkTaskDelegate.swift
//  Jarvis
//
//  Created by Michal on 26/10/2020.
//

import Foundation

extension HttpClient: NetworkTaskDelegate {
    func didFinishTask(_ task: NetworkTask) {
        if let index = activeTasks.firstIndex(where: { $0.id == task.id }) {
            activeTasks.remove(at: index)
        }
    }
    
    func dataTaskFor(urlRequest: URLRequest) -> URLSessionDataTask? {
        return urlSession.dataTask(with: urlRequest)
    }
    
    func downloadTaskFor(urlRequest: URLRequest) -> URLSessionDownloadTask? {
        return urlSession.downloadTask(with: urlRequest)
    }
    
    func uploadTaskFor(urlRequest: URLRequest, uploadDataProvider: UploadDataProvider) -> URLSessionUploadTask? {
        switch uploadDataProvider {
        case .memory(let data): return urlSession.uploadTask(with: urlRequest, from: data)
        case .file(let fileUrl): return urlSession.uploadTask(with: urlRequest, fromFile: fileUrl)
        }
    }
}
