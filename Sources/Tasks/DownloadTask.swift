//
//  DownloadTask.swift
//  Jarvis
//
//  Created by Michal on 31/10/2020.
//

import Foundation

protocol DownloadingTask: NetworkTask, NetworkTaskCompletable {
    func didFinishDownloadingTo(to location: URL)
    func addCompletion(_ handler: @escaping (Result<DownloadResponse, Error>) -> Void) -> Self
}

public final class DownloadTask: DownloadingTask {
    public let id: UUID
    public let request: Request
    public internal(set) var state: NetworkTaskState
    public internal(set) var task: URLSessionTask?
    
    internal unowned var httpClient: HttpClient
    internal weak var delegate: NetworkTaskDelegate?
    internal let downloadLocation: DownloadLocation
    internal let requestAdapter: URLRequestAdapting
    internal let responseAdapter: URLResponseAdapting
    internal var isCompleting: Bool
    internal var completionHandlers: [(Result<DownloadResponse, Error>) -> Void]

    private var result: Result<DownloadResponse, Error>?
    private var downloadedFileLocation: URL?
    private var fileManager: FileManager
        
    internal init(
        request: Request,
        httpClient: HttpClient,
        downloadLocation: DownloadLocation,
        delegate: NetworkTaskDelegate,
        requestAdapter: URLRequestAdapting = URLRequestAdapter(),
        responseAdapter: URLResponseAdapting = URLResponseAdapter(),
        fileManager: FileManager = .default
    ) {
        self.id = UUID()
        self.request = request
        self.httpClient = httpClient
        self.delegate = delegate
        self.downloadLocation = downloadLocation
        self.requestAdapter = requestAdapter
        self.responseAdapter = responseAdapter
        self.state = .initialized
        self.isCompleting = false
        self.completionHandlers = []
        self.fileManager = fileManager
        
        do {
            self.task = try makeURLSessionTask()
        } catch {
            finishTask(error: error)
        }
    }
    
    deinit {
        print("[DEINIT] DownloadTask \(id.uuidString)")
    }
    
    public func resume() {
        guard state.canTransitionTo(.inProgress) else {
            return
        }
        
        state = .inProgress
        task?.resume()
    }
    
    public func suspend() {
        guard state.canTransitionTo(.suspended) else {
            return
        }
        
        state = .suspended
        task?.suspend()
    }
    
    public func cancel() {
        guard state.canTransitionTo(.cancelled) else {
            return
        }
        
        state = .cancelled
        task?.cancel()
        
        finishTask(error: NetworkTaksError.cancelled)
    }
    
    @discardableResult public func addCompletion(_ handler: @escaping (Result<DownloadResponse, Error>) -> Void) -> Self {
        completionHandlers.append(handler)
        
        // If task is finished and already has result, then execute completion handler right away
        if let result = self.result {
            handler(result)
        }
        
        return self
    }
}

// MARK: - DownloadingTask
internal extension DownloadTask{
    func didFinishDownloadingTo(to location: URL) {
        do {
            downloadedFileLocation = try moveDownloadedFileIfNecessary(location)
        } catch {
            downloadedFileLocation = location
        }
    }
    
    func completeWith(error: Error?) {
        guard state.canTransitionTo(.completed) else {
            return
        }
        
        self.state = .completed
        finishTask(error: error)
    }
}

// MARK: - Helpers
private extension DownloadTask {
    func makeURLSessionTask() throws -> URLSessionTask? {
        guard let urlRequest = requestAdapter.map(request: request, usingConfiguration: httpClient.configuration) else {
            throw NetworkTaksError.urlSessionTaskCreationFailed
        }
        
        return delegate?.downloadTaskFor(urlRequest: urlRequest)
    }
    
    func finishTask(error: Error? = nil) {
        guard !isCompleting else {
            return
        }
        
        self.isCompleting = true
        
        let result: Result<DownloadResponse, Error>

        if let error = error {
            result = .failure(error)
        } else if let urlResponse = task?.response as? HTTPURLResponse,
                  let response = responseAdapter.map(httpUrlResponse: urlResponse, data: nil, for: request),
                  let downloadedFileLocation = self.downloadedFileLocation
        {
            let downloadResponse = DownloadResponse(fileLocation: downloadedFileLocation, respnse: response)
            result = .success(downloadResponse)
        } else {
            result = .failure(NetworkTaksError.responseSerializationFailed)
        }
        
        self.result = result
        state = .completed
        
        executeCompletionHandlers(with: result)
        delegate?.didFinishTask(self)
    }
    
    func executeCompletionHandlers(with result: Result<DownloadResponse, Error>) {
        completionHandlers.forEach {
            $0(result)
        }
    }
}

// MARK: - Move file after download
private extension DownloadTask {
    func moveDownloadedFileIfNecessary(_ downloadedFileLocation: URL) throws -> URL {
        guard let desitinationUrl = downloadLocation.locationUrl else {
            return downloadedFileLocation
        }
        
        let fileName: String = {
            switch downloadLocation.fileName {
            case .original: return fileNameFromRequest()
            case .renamed(let newFileName): return newFileName
            }
        }()
        
        let fullDestinationUrl = desitinationUrl.appendingPathComponent(fileName)
        
        do {
            if downloadLocation.options.contains(.replaceExistingFile), fileManager.fileExists(atPath: fullDestinationUrl.path) {
                try fileManager.removeItem(at: fullDestinationUrl)
            }
            
            if downloadLocation.options.contains(.createIntermediateDirectories) {
                let directory = desitinationUrl.deletingLastPathComponent()
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            }
            
            try fileManager.moveItem(at: downloadedFileLocation, to: fullDestinationUrl)
            return fullDestinationUrl
        } catch {
            throw DownloadTaskError.downloadedFileMoveFailed
        }
    }
    
    func fileNameFromRequest() -> String {
        guard let path = request.target?.path, let url = URL(string: path) else {
            return "\(UUID().uuidString).temp"
        }
        
        return url.lastPathComponent
    }
}
