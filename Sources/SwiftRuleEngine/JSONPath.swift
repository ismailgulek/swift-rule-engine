//
//  JSONPath.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 20/02/2023.
//

import Foundation

enum JSONPathError: Error {
    case valueNotFound
    case invalidPath
    case expectingDictionary
}

enum JSONPart {
    case key(String)
    case index(Int)
}

public struct JSONPath {
    private let parts: [JSONPart]
    private let pathRegex = try! NSRegularExpression(pattern: #"\$\.((\w+\[\d+\](\.|$)|(\w+\.)))*(\w+\[\d+\]|\w+)$"#)

    init(_ path: String) throws {
        guard path != "$" else {
            self.parts = []
            return
        }

        guard pathRegex.firstMatch(in: path, options: [],
                                   range: NSRange(location: 0, length: path.count)) != nil
        else {
            throw JSONPathError.invalidPath
        }

        var parts = [JSONPart]()
        for component in path.split(separator: ".") {
            guard component != "$" else {
                continue
            }
            if component.hasSuffix("]") {
                let key = component.split(separator: "[")[0]
                guard let index = Int(component.split(separator: "[")[1].split(separator: "]")[0]) else {
                    throw JSONPathError.invalidPath
                }
                parts.append(.key(String(key)))
                parts.append(.index(index))
            } else {
                parts.append(.key(String(component)))
            }
        }
        self.parts = parts
    }

    private func accessObj(_ key: String, _ obj: any StringSubscriptable) throws -> Any {
        if let value = obj[key] {
            return value
        } else if obj[key] == nil {
            return NSNull()
        } else {
            throw JSONPathError.valueNotFound
        }
    }

    private func accessArray(_ index: Int, _ array: [Any]) throws -> Any {
        if index < array.count {
            return array[index]
        } else {
            throw JSONPathError.valueNotFound
        }
    }

    func getValue(for obj: Any) throws -> Any {
        var currentObj: Any = obj

        for p in parts {
            switch p {
            case let .key(key):
                guard let subscriptableObj = currentObj as? any StringSubscriptable else {
                    throw JSONPathError.expectingDictionary
                }
                currentObj = try accessObj(key, subscriptableObj)
            case let .index(index):
                guard let array = currentObj as? [Any] else {
                    throw JSONPathError.expectingDictionary
                }
                currentObj = try accessArray(index, array)
            }
        }
        return currentObj
    }
}
