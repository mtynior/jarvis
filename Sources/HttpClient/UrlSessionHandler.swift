//
//  UrlSessionHandler.swift
//  Jarvis
//
//  Created by Michal on 26/10/2020.
//

import Foundation

internal final class UrlSessionHandler: NSObject {
    weak var httpClient: HttpClient?
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
}

// MARK: - URLSessionDataDelegate
extension UrlSessionHandler: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataTask = httpClient?.activeTasks[dataTask] as? DataFetchingTask {
            dataTask.didReceiveData(data)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let dataTask = httpClient?.activeTasks[task] as? NetworkTaskCompletable {
            dataTask.completeWith(error: error)
        }
    }
}

// MARK: - URLSessionDownloadDelegate
extension UrlSessionHandler: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let downloadTask = httpClient?.activeTasks[downloadTask] as? DownloadTask {
            downloadTask.didFinishDownloadingTo(to: location)
        }
    }
}
