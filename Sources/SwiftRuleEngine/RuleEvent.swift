//
//  RuleEvent.swift
//  RuleEngineDemo
//
//  Created by Ismail on 11.09.2024.
//

import Foundation

public struct RuleEvent: Decodable {
    public let type: String
    public let params: [String: Any]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        params = try? container.decode([String: Any].self, forKey: .params)
    }

    public enum CodingKeys: String, CodingKey {
        case type, params
    }
}
