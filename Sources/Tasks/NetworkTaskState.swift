//
//  NetworkTaskState.swift
//  Jarvis
//
//  Created by Michal on 26/10/2020.
//

import Foundation

public enum NetworkTaskState: Equatable {
    case initialized
    case configuring
    case inProgress
    case completed
    case cancelled
    case suspended
    
    func canTransitionTo(_ newState: NetworkTaskState) -> Bool {
        switch (self, newState) {
        case (.initialized, _): return true
        case (.configuring, _): return true
        case (.inProgress, .suspended), (.inProgress, .cancelled), (.inProgress, .completed): return true
        case (.suspended, .inProgress), (.suspended, .cancelled): return true
        default: return false
        }
    }
}
