//
//  Rule.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

public struct Rule: Decodable {
    public let name: String
    public let description: String?
    public let extra: [String: Any]?
    public let priority: Int
    public var conditions: MultiCondition
    public let event: RuleEvent?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        extra = try? container.decode([String: Any].self, forKey: .extra)
        priority = try container.decodeIfPresent(Int.self, forKey: .priority) ?? 1
        conditions = try container.decode(MultiCondition.self, forKey: .conditions)
        event = try container.decodeIfPresent(RuleEvent.self, forKey: .event)
    }

    public enum CodingKeys: String, CodingKey {
        case name, description, extra, priority, conditions, event
    }
}
