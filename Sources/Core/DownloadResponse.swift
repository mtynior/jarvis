//
//  DownloadResponse.swift
//  Jarvis
//
//  Created by Michal on 31/10/2020.
//

import Foundation

public struct DownloadResponse {
    public let fileLocation: URL
    public let reponse: DataResponse?
    
    init(fileLocation: URL, respnse: DataResponse?) {
        self.fileLocation = fileLocation
        self.reponse = respnse
    }
}

// MARK: - CustomStringConvertible
extension DownloadResponse: CustomStringConvertible {
    public var description: String {
        return DescriptionBuilder()
            .addLine("File Location")
            .addLine(fileLocation.absoluteString, indentation: 1)
            .addLine("Response")
            .addLine(reponse?.description, placeholder: "None", indentation: 1)
            .description
    }
}
