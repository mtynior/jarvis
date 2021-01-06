//
//  UploadDataProvider.swift
//  Jarvis
//
//  Created by Michal on 07/11/2020.
//

import Foundation

public enum UploadDataProvider: Equatable {
    case memory(Data)
    case file(URL)
}
