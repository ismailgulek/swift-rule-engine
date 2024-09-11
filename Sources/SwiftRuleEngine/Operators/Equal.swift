//
//  Equal.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation

struct Equal: Operator {
    static let id = OperatorID(rawValue: "equal")
    private let value: AnyCodable

    init(value: AnyCodable, params _: [String: Any]?) throws {
        self.value = value
    }

    private func castAndCompare<T: Equatable>(_ lhs: Any, _ rhs: Any, type _: T.Type) -> Bool {
        guard let rhs = rhs as? T,
              let lhs = lhs as? T
        else {
            return false
        }

        return lhs == rhs
    }

    func match(_ objValue: Any) -> Bool {
        switch value {
        case let .string(lhs):
            return castAndCompare(lhs, objValue, type: String.self)

        case let .number(lhs):
            return castAndCompare(lhs, objValue, type: NSNumber.self)

        case let .bool(lhs):
            return castAndCompare(lhs, objValue, type: Bool.self)

        case let .dictionary(lhs):
            return castAndCompare(lhs, objValue, type: NSDictionary.self)

        case let .array(lhs):
            return castAndCompare(lhs, objValue, type: NSArray.self)

        case .null:
            if case Optional<Any>.none = objValue {
                return true
            } else if objValue is NSNull {
                return true
            }
            return false

        default:
            return false
        }
    }
}
