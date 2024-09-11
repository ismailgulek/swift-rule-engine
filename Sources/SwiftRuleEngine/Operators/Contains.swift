//
//  Contains.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation

struct Contains: Operator {
    static let id = OperatorID(rawValue: "contains")
    private let value: AnyCodable

    init(value: AnyCodable, params _: [String: Any]?) throws {
        self.value = value
    }

    func match(_ objValue: Any) -> Bool {
        if let rhs = objValue as? NSArray {
            return rhs.contains(value.value())
        }

        if let rhs = objValue as? String,
           let lhs = value.value() as? String
        {
            return rhs.contains(lhs)
        }

        return false
    }
}
