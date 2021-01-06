//
//  File.swift
//  Jarvis
//
//  Created by Michal on 11/10/2020.
//

import Foundation

public struct HttpHeaders {
    public internal(set) var fields: [Field]
    
    public var count: Int {
        return fields.count
    }
    
    public init(fields: [Field] = []) {
        self.fields = fields
    }
    
    public init(dictionary: [String: String]) {
        let fields: [Field] = dictionary.map { Field(name: $0.key, value: $0.value) }
        self.init(fields: fields)
    }
}

// MARK: - Modifying
public extension HttpHeaders {
    mutating func add(_ field: Field) {
        fields.append(field)
    }
    
    mutating func add(fields: [Field]) {
        fields.forEach {
            add($0)
        }
    }
    
    mutating func add(headers: HttpHeaders) {
        add(fields: headers.fields)
    }
    
    mutating func set(_ field: Field) {
        var fieldAlredyExist = false
        
        for (index, existingField) in fields.enumerated() {
            if existingField.name == field.name {
                fieldAlredyExist = true
                fields[index].value = field.value
            }
        }
        
        if !fieldAlredyExist {
            add(field)
        }
    }
    
    mutating func remove(name: String) {
        fields.removeAll(where: { $0.name == name })
    }
}

// MARK: - Querying
extension HttpHeaders {
    public func first(name: String) -> String? {
        return fields.first(where: { $0.name == name })?.value
    }
    
    public func last(name: String) -> String? {
        return fields.last(where: { $0.name == name })?.value
    }
    
    public func all(name: String) -> [String] {
        return fields
            .filter { $0.name == name }
            .map { $0.value }
    }
    
    public var names: Set<String> {
        let allNames = fields.map { $0.name }
        return Set(allNames)
    }
    
    public var values: Set<String> {
        let allValues = fields.map { $0.value }
        return Set(allValues)
    }
}

// MARK: - Equatable
extension HttpHeaders: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
    
        let sortedLhs = lhs.fields.sorted(by: { $0.name < $1.name })
        let sortedRhs = rhs.fields.sorted(by: { $0.name < $1.name })

        for index in 0..<sortedLhs.count {
            if sortedLhs[index] != sortedRhs[index] {
                return false
            }
        }
        
        return true
    }
}

// MARK: - CustomStringConvertible
extension HttpHeaders: CustomStringConvertible {
    public var description: String {
        guard fields.count > 0 else {
            return "None"
        }
        
        return fields
            .map({ $0.description })
            .joined(separator: "\n")
    }
}

// MARK: - HttpHeaders.Field
public extension HttpHeaders {
    struct Field: Equatable {
        public var name: String
        public var value: String
        
        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
}

// MARK: - HttpHeaders.Field CustomStringConvertible
extension HttpHeaders.Field: CustomStringConvertible {
    public var description: String {
        return "\(name) : \(value)"
    }
}
