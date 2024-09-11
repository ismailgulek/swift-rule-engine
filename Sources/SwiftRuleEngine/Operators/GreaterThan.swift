//
//  GreaterThan.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation

struct GreaterThan: Operator {
    static let id = OperatorID(rawValue: "greaterThan")
    private let value: AnyCodable

    init(value: AnyCodable, params _: [String: Any]?) throws {
        self.value = value
    }

    func match(_ objValue: Any) -> Bool {
        switch value {
        case let .number(lhs):
            guard let rhs = objValue as? NSNumber else {
                return false
            }

            return lhs.doubleValue < rhs.doubleValue

        case let .string(lhs):
            guard let rhs = objValue as? String else {
                return false
            }

            return lhs < rhs

        default:
            return false
        }
    }
}
