//
//  LessThan.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct LessThan: Operator {
    static let id = OperatorID.less_than
    private let value: AnyCodable

    init(value: AnyCodable, params: [String : Any]?) throws {
        self.value = value
    }

    func match(_ objValue: Any) -> Bool {
        switch self.value.valueType {
        case .number:
            guard let lhs = self.value.value as? NSNumber,
                  let rhs = objValue as? NSNumber else {
                return false
            }

            return lhs.doubleValue > rhs.doubleValue

        case .string:
            guard let lhs = self.value.value as? String,
                  let rhs = objValue as? String else {
                return false
            }

            return lhs > rhs

        default:
            return false
        }
    }
}

