//
//  HttpClient.swift
//  Jarvis
//
//  Created by Michal on 11/10/2020.
//

import Foundation

public final class HttpClient {
    public internal(set) var configuration: HttpClient.Configuration = .default
    
    public static let shared = HttpClient()
    
    internal var activeTasks: NetworkTaskRepository = NetworkTaskRepository()
    internal let urlSessionConfiguration: URLSessionConfiguration
    internal lazy var urlSession: URLSession = { URLSession(configuration: urlSessionConfiguration, delegate: self.urlSessionHandler, delegateQueue: .init()) }()
    internal lazy var urlSessionHandler: UrlSessionHandler = { UrlSessionHandler(httpClient: self) }()

    public init(urlSessionConfiguration: URLSessionConfiguration = .default) {
        self.urlSessionConfiguration = urlSessionConfiguration
    }
    
    deinit {
        finishTasksForDeinit()
        urlSession.invalidateAndCancel()
    }
}

// MARK: - Builder
public extension HttpClient {
    func configuration(_ configuration: HttpClient.Configuration) -> Self {
        self.configuration = configuration
        return self
    }
    
    func baseUrl(_ url: HttpUrl?) -> Self {
        configuration.baseUrl = url
        return self
    }
}

// MARK: - Tasks
public extension HttpClient {
    @discardableResult func send(_ request: Request) -> FetchDataTask {
        return send(request, callback: nil)
    }
    
    @discardableResult func send(_ request: Request, callback: ((Result<DataResponse, Error>) -> Void)?) -> FetchDataTask {
        let fetchTask = FetchDataTask(request: request, httpClient: self, delegate: self)
            
        if let callback = callback {
            fetchTask.addCompletion(callback)
        }
            
        self.activeTasks.add(fetchTask)
        
        if configuration.automaticallyStartRequest {
            fetchTask.resume()
        }
        
        return fetchTask
    }
    
    @discardableResult func download(_ request: Request, downloadLocation: DownloadLocation = .default) -> DownloadTask {
        return download(request, downloadLocation: downloadLocation, callback: nil)
    }
    
    @discardableResult func download(_ request: Request, downloadLocation: DownloadLocation = .default, callback: ((Result<DownloadResponse, Error>) -> Void)?) -> DownloadTask {
        let downloadTask = DownloadTask(request: request, httpClient: self, downloadLocation: downloadLocation, delegate: self)
        
        if let callback = callback {
            downloadTask.addCompletion(callback)
        }
        
        self.activeTasks.add(downloadTask)
        
        if configuration.automaticallyStartRequest {
            downloadTask.resume()
        }
        
        return downloadTask
    }
    
    @discardableResult func upload(_ request: Request) -> UploadTask {
        return upload(request, callback: nil)
    }
    
    @discardableResult func upload(_ request: Request, callback: ((Result<DataResponse, Error>) -> Void)?) -> UploadTask {
        let uploadDataProvider: UploadDataProvider? = {
            if let data = request.body?.data {
                return .memory(data)
            }
            return nil
        }()
        
        let uploadTask = UploadTask(request: request, uploadDataProvider: uploadDataProvider, httpClient: self, delegate: self)
       
        if let callback = callback {
            uploadTask.addCompletion(callback)
        }
        
        self.activeTasks.add(uploadTask)
        
        if configuration.automaticallyStartRequest {
            uploadTask.resume()
        }
        
        return uploadTask
    }
}

// MARK: - Helpers
private extension HttpClient {
    func finishTasksForDeinit() {
        activeTasks.compactMap({ $0 as? NetworkTaskCompletable }).forEach {
            $0.completeWith(error: HttpClientError.clientDeinitialized)
        }
    }
}
