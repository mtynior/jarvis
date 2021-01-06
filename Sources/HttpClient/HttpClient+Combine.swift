//
//  HttpClient+Combine.swift
//  Jarvis
//
//  Created by Michal on 18/11/2020.
//

#if canImport(Combine)
import Combine

// MARK: - Publishers and Subscribers
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public struct DataReponsePublisher: Publisher {
    public typealias Output = DataResponse
    public typealias Failure = Error
    
    private unowned var task: DataFetchingTask
    
    init(task: DataFetchingTask) {
        self.task = task
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = ResponseSubscriber<S, Self.Output>(task: task, downstream: subscriber)
        
        subscriber.receive(subscription: subscription)
        
        _ = task.addCompletion(subscription.complete)
    }
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public struct DownloadReponsePublisher: Publisher {
    public typealias Output = DownloadResponse
    public typealias Failure = Error
    
    private unowned var task: DownloadingTask
    
    init(task: DownloadingTask) {
        self.task = task
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = ResponseSubscriber<S, Self.Output>(task: task, downstream: subscriber)
        
        subscriber.receive(subscription: subscription)
        
        _ = task.addCompletion(subscription.complete)
    }
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
class ResponseSubscriber<Downstream: Subscriber, ResponseType>: Subscription where Downstream.Input == ResponseType, Downstream.Failure == Error {
    private var downstream: Downstream?
    private weak var task: NetworkTask?
    
    init(task: NetworkTask, downstream: Downstream) {
        self.task = task
        self.downstream = downstream
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        task?.cancel()
        downstream = nil
    }
    
    func complete(_ result: Result<ResponseType, Error>) {
        switch result {
        case .success(let response):
            _ = downstream?.receive(response)
        case .failure(let error):
            _ = downstream?.receive(completion: .failure(error))
        }
    }
}

// MARK: - Extentions
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension FetchDataTask {
    public func publisher() -> DataReponsePublisher {
        return DataReponsePublisher(task: self)
    }
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension DownloadTask {
    public func publisher() -> DownloadReponsePublisher {
        return DownloadReponsePublisher(task: self)
    }
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension UploadTask {
    public func publisher() -> DataReponsePublisher {
        return DataReponsePublisher(task: self)
    }
}

#endif
