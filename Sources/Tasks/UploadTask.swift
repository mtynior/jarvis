//
//  UploadTask.swift
//  Jarvis
//
//  Created by Michal on 07/11/2020.
//

import Foundation

public final class UploadTask: DataFetchingTask {
    public let id: UUID
    public let request: Request
    public internal(set) var uploadDataProvider: UploadDataProvider?
    public internal(set) var state: NetworkTaskState
    public internal(set) var task: URLSessionTask?
    
    internal unowned var httpClient: HttpClient
    internal weak var delegate: NetworkTaskDelegate?
    internal let requestAdapter: URLRequestAdapting
    internal let responseAdapter: URLResponseAdapting
    internal var isCompleting: Bool
    internal var completionHandlers: [(Result<DataResponse, Error>) -> Void]

    private var receivedDataBuffer: Data?
    private var result: Result<DataResponse, Error>?
    private var fileManager: FileManager
        
    internal init(
        request: Request,
        uploadDataProvider: UploadDataProvider?,
        httpClient: HttpClient,
        delegate: NetworkTaskDelegate,
        requestAdapter: URLRequestAdapting = URLRequestAdapter(),
        responseAdapter: URLResponseAdapting = URLResponseAdapter(),
        fileManager: FileManager = .default
    ) {
        self.id = UUID()
        self.request = request
        self.uploadDataProvider = uploadDataProvider
        self.httpClient = httpClient
        self.delegate = delegate
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
    
    @discardableResult public func addCompletion(_ handler: @escaping (Result<DataResponse, Error>) -> Void) -> Self {
        completionHandlers.append(handler)
        
        // If task is finished and already has result, then execute completion handler right away
        if let result = self.result {
            handler(result)
        }
        
        return self
    }
}

// MARK: - UploadingTask
internal extension UploadTask {
    func didReceiveData(_ data: Data) {
        if self.receivedDataBuffer == nil {
            self.receivedDataBuffer = data
        } else {
            self.receivedDataBuffer?.append(data)
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
private extension UploadTask {
    func makeURLSessionTask() throws -> URLSessionTask? {
        guard let urlRequest = requestAdapter.map(request: request, usingConfiguration: httpClient.configuration) else {
            throw NetworkTaksError.urlSessionTaskCreationFailed
        }
        
        guard let uploadDataProvider = uploadDataProvider else {
            throw NetworkTaksError.emptyRequestBody
        }
    
        return delegate?.uploadTaskFor(urlRequest: urlRequest, uploadDataProvider: uploadDataProvider)
    }
    
    func finishTask(error: Error? = nil) {
        guard !isCompleting else {
            return
        }
        
        self.isCompleting = true
        
        let result: Result<DataResponse, Error>

        if let error = error {
            result = .failure(error)
        } else if let urlResponse = task?.response as? HTTPURLResponse, let response = responseAdapter.map(httpUrlResponse: urlResponse, data: self.receivedDataBuffer, for: request) {
           result = .success(response)
        } else {
            result = .failure(NetworkTaksError.responseSerializationFailed)
        }
        
        self.result = result
        state = .completed
        
        executeCompletionHandlers(with: result)
        delegate?.didFinishTask(self)
    }
    
    func executeCompletionHandlers(with result: Result<DataResponse, Error>) {
        completionHandlers.forEach {
            $0(result)
        }
    }
}
