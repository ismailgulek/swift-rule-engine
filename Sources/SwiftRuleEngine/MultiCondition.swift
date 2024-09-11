//
//  MultiCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation

public struct MultiCondition: Condition {
    public var match: Bool = false
    public var all: [Condition]?
    public var any: [Condition]?
    public var not: Condition?

    public mutating func evaluate(_ obj: Any) throws {
        if all != nil {
            try evaluateAll(obj)
        } else if any != nil {
            try evaluateAny(obj)
        } else if not != nil {
            try evaluateNot(obj)
        }
    }

    private mutating func evaluateAny(_ obj: Any) throws {
        for i in any!.indices {
            try any![i].evaluate(obj)
            if any![i].match {
                match = true
                return
            }
        }
    }

    private mutating func evaluateAll(_ obj: Any) throws {
        for i in all!.indices {
            try all![i].evaluate(obj)
            if !all![i].match {
                match = false
                return
            }
        }
        match = true
    }

    private mutating func evaluateNot(_ obj: Any) throws {
        try not!.evaluate(obj)
        match = !not!.match
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        any = try Self.decodeConditionArray(container, .any)
        all = try Self.decodeConditionArray(container, .all)
        not = try Self.decodeCondition(container, .not)

        guard (any == nil && all == nil && not != nil) ||
            (any == nil && all != nil && not == nil) ||
            (any != nil && all == nil && not == nil)
        else {
            throw DecodingError.typeMismatch(MultiCondition.self,
                                             DecodingError.Context(codingPath: decoder.codingPath,
                                                                   debugDescription: "Only one of any, all or not should be present"))
        }
    }

    private static func decodeConditionArray(_ container: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) throws -> [Condition]? {
        guard container.contains(key) else {
            return nil
        }

        var conditionArray: [Condition] = []
        var conditionArrayContainer = try container.nestedUnkeyedContainer(forKey: key)
        while !conditionArrayContainer.isAtEnd {
            if let condition = try? conditionArrayContainer.decode(MultiCondition.self) {
                conditionArray.append(condition)
            } else if let condition = try? conditionArrayContainer.decode(SimpleCondition.self) {
                conditionArray.append(condition)
            } else {
                throw DecodingError.typeMismatch(Condition.self,
                                                 DecodingError.Context(codingPath: container.codingPath,
                                                                       debugDescription: "Missing conditions for multi condition"))
            }
        }
        return conditionArray
    }

    private static func decodeCondition(_ container: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) throws -> Condition? {
        guard container.contains(key) else {
            return nil
        }

        if let condition = try? container.decode(MultiCondition.self, forKey: key) {
            return condition
        } else if let condition = try? container.decode(SimpleCondition.self, forKey: key) {
            return condition
        } else {
            throw DecodingError.typeMismatch(Condition.self,
                                             DecodingError.Context(codingPath: container.codingPath,
                                                                   debugDescription: "Missing conditions for multi condition"))
        }
    }

    private enum CodingKeys: String, CodingKey {
        case all, any, not
    }
}
