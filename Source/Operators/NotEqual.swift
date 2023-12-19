//
//  NotEqual.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct NotEqual: Operator {
    static let id = OperatorID(rawValue: "not_equal")
    private let value: AnyCodable

    init(value: AnyCodable, params: [String : Any]?) throws {
        self.value = value
    }

    private func castAndCompare<T: Equatable>(_ lhs: Any, _ rhs: Any, type: T.Type) -> Bool {
        guard let rhs = rhs as? T,
              let lhs = lhs as? T else {
            return false
        }

        return lhs != rhs
    }

    func match(_ objValue: Any) -> Bool {

        switch self.value.valueType {
        case .string:
            return castAndCompare(self.value.value, objValue, type: String.self)

        case .number:
            return castAndCompare(self.value.value, objValue, type: NSNumber.self)

        case .bool:
            return castAndCompare(self.value.value, objValue, type: Bool.self)

        case .dictionary:
            return castAndCompare(self.value.value, objValue, type: NSDictionary.self)

        case .array:
            return castAndCompare(self.value.value, objValue, type: NSArray.self)

        case .null:
            if case Optional<Any>.none = objValue  {
                return false
            } else if objValue is NSNull {
                return false
            }
            return true

        default:
            return false
        }
    }
}
