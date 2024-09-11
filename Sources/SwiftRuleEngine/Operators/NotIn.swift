//
//  NotIn.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation

struct NotIn: Operator {
    static let id = OperatorID(rawValue: "notIn")
    private let value: Any

    init(value: AnyCodable, params _: [String: Any]?) throws {
        switch value {
        case let .string(string):
            self.value = string
        case let .array(array):
            if let array = array as? [AnyHashable] {
                self.value = Set(array)
            } else {
                self.value = array as NSArray
            }
        default:
            throw OperatorError.invalidValueType
        }
    }

    func match(_ objValue: Any) -> Bool {
        if let lhs = value as? String, let rhs = objValue as? String {
            return !lhs.contains(rhs)
        } else if let lhs = value as? Set<AnyHashable>, let rhs = objValue as? AnyHashable {
            return !lhs.contains(rhs)
        } else if let lhs = value as? NSArray {
            return !lhs.contains(objValue)
        }
        return true
    }
}
