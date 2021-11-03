//
//  NetworkTaskDelegate.swift
//  Jarvis
//
//  Created by Michal on 26/10/2020.
//

import Foundation

internal protocol NetworkTaskDelegate: AnyObject {
    func didFinishTask(_ task: NetworkTask)
    func dataTaskFor(urlRequest: URLRequest) -> URLSessionDataTask?
    func downloadTaskFor(urlRequest: URLRequest) -> URLSessionDownloadTask?
    func uploadTaskFor(urlRequest: URLRequest, uploadDataProvider: UploadDataProvider) -> URLSessionUploadTask?
}

extension NetworkTaskDelegate {
    func didFinishTask(_ task: NetworkTask) { }
    func dataTaskFor(urlRequest: URLRequest) -> URLSessionDataTask? { return nil }
    func downloadTaskFor(urlRequest: URLRequest) -> URLSessionDownloadTask? { return nil }
    func uploadTaskFor(urlRequest: URLRequest, uploadDataProvider: UploadDataProvider) -> URLSessionUploadTask? { return nil }
}
