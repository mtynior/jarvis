//
//  QueryParameters.swift
//  Jarvis
//
//  Created by Michal on 11/10/2020.
//

import Foundation

public struct QueryParameters {
    public internal(set) var parameters: [Parameter]
    
    public var count: Int {
        return parameters.count
    }
    
    public init(parameters: [Parameter] = []) {
        self.parameters = parameters
    }
    
    public init(dictionary: [String: String]) {
        let parameters: [Parameter] = dictionary.map { Parameter(name: $0.key, value: $0.value) }
        self.init(parameters: parameters)
    }
}

// MARK: - Modifying
public extension QueryParameters {
    mutating func add(_ parameter: Parameter) {
        parameters.append(parameter)
    }
    
    mutating func add(parameters: [Parameter]) {
        parameters.forEach {
            add($0)
        }
    }
    
    mutating func add(parameters: QueryParameters) {
        add(parameters: parameters.parameters)
    }
    
    mutating func set(_ parameter: Parameter) {
        var paramterAlredyExist = false
        
        for (index, existingParameter) in parameters.enumerated() {
            if existingParameter.name == parameter.name {
                paramterAlredyExist = true
                parameters[index].value = parameter.value
            }
        }
        
        if !paramterAlredyExist {
            add(parameter)
        }
    }
    
    mutating func remove(name: String) {
        parameters.removeAll(where: { $0.name == name })
    }
}

// MARK: - Querying
extension QueryParameters {
    public func first(name: String) -> String? {
        return parameters.first(where: { $0.name == name })?.value
    }
    
    public func last(name: String) -> String? {
        return parameters.last(where: { $0.name == name })?.value
    }
    
    public func all(name: String) -> [String] {
        return parameters
            .filter { $0.name == name }
            .map { $0.value }
    }
    
    public var names: Set<String> {
        let allNames = parameters.map { $0.name }
        return Set(allNames)
    }
    
    public var values: Set<String> {
        let allValues = parameters.map { $0.value }
        return Set(allValues)
    }
}

// MARK: - Equatable
extension QueryParameters: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
    
        let sortedLhs = lhs.parameters.sorted(by: { $0.name < $1.name })
        let sortedRhs = rhs.parameters.sorted(by: { $0.name < $1.name })

        for index in 0..<sortedLhs.count {
            if sortedLhs[index] != sortedRhs[index] {
                return false
            }
        }
        
        return true
    }
}

// MARK: - CustomStringConvertible
extension QueryParameters: CustomStringConvertible {
    public var description: String {
        guard parameters.count > 0 else {
            return "None"
        }
        
        return parameters
            .map({ $0.description })
            .joined(separator: "\n")
    }
}

// MARK: - QueryParameters.Parameter
public extension QueryParameters {
    struct Parameter: Equatable {
        public var name: String
        public var value: String
        
        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
}

// MARK: - QueryParameters.Parameter CustomStringConvertible
extension QueryParameters.Parameter: CustomStringConvertible {
    public var description: String {
        return "\(name) : \(value)"
    }
}

// MARK: - URLQueryItem
extension QueryParameters.Parameter {
    public var urlQueryItem: URLQueryItem {
        return URLQueryItem(name: name, value: value)
    }
}

