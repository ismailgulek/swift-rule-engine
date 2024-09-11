//
//  ContainsRegex.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 04/04/2023.
//

import Foundation

struct ContainsRegex: Operator {
    static let id = OperatorID(rawValue: "contains_regex")
    private let regex: NSRegularExpression

    init(value: AnyCodable, params _: [String: Any]?) throws {
        if case let .string(pattern) = value {
            guard let reg = try? NSRegularExpression(pattern: pattern) else {
                throw OperatorError.invalidValue
            }
            regex = reg
            return
        }
        throw OperatorError.invalidValueType
    }

    func match(_ objValue: Any) -> Bool {
        guard let rhs = objValue as? [String] else {
            return false
        }

        return rhs.contains { string in
            let range = NSRange(location: 0, length: string.utf16.count)
            return regex.firstMatch(in: string, range: range) != nil
        }
    }
}
