//
//  NotRegex.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 11/04/2023.
//

import Foundation

struct NotRegex: Operator {
    static let id = OperatorID(rawValue: "not_regex")
    let regex: NSRegularExpression

    init(value: AnyCodable, params _: [String: Any]?) throws {
        guard case let .string(pattern) = value else {
            throw OperatorError.invalidValueType
        }

        guard let reg = try? NSRegularExpression(pattern: pattern) else {
            throw OperatorError.invalidValue
        }
        regex = reg
    }

    func match(_ objValue: Any) -> Bool {
        guard let rhs = objValue as? String else {
            return true
        }

        let range = NSRange(location: 0, length: rhs.utf16.count)
        return regex.firstMatch(in: rhs, range: range) == nil
    }
}
