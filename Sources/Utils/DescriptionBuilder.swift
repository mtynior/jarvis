//
//  DescriptionBuilder.swift
//  Harvis
//
//  Created by Michal on 27/10/2020.
//

import Foundation

final class DescriptionBuilder {
    private var descriptionContainer: String
    private let lineTerminator: String
    
    var description: String {
        return descriptionContainer.removingSuffix(lineTerminator)
    }
    
    init(lineTerminator: String = "\n") {
        self.lineTerminator = lineTerminator
        self.descriptionContainer = ""
    }
    
    init(_ initialDescription: String = "", lineTerminator: String = "\n") {
        self.lineTerminator = lineTerminator
        self.descriptionContainer = "\(initialDescription)\(lineTerminator)"
    }
    
    func addLine(_ string: String?, placeholder: String = "", indentation: Int = 0) -> Self {
        let normalizedValue: String = {
            guard let string = string else {
                return placeholder
            }
            return reindent(string, indentation: indentation)
        }()
        
        let indentation = String(repeating: "\t", count: indentation)
        
        descriptionContainer += "\(indentation)\(normalizedValue)\(lineTerminator)"
        
        return self
    }
    
    private func reindent(_ string: String, indentation: Int) -> String {
        let indentation = String(repeating: "\t", count: indentation)
        return string.replacingOccurrences(of: "\n", with: "\n\(indentation)").removingSuffix("\t")
    }
}
