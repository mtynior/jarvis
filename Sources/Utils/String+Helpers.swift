//
//  String+Helpers.swift
//  Jarvis
//
//  Created by Michal on 13/10/2020.
//

import Foundation

internal extension String {
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else {
            return self
        }
        
        return String(dropLast(suffix.count))
    }
}
