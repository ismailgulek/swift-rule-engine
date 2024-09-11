//
//  AnyCodable.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

public enum AnyCodable: Decodable {
    case number(_ value: NSNumber)
    case string(_ value: String)
    case bool(_ value: Bool)
    case array(_ value: [Any])
    case dictionary(_ value: [String: Any])
    case null(_ value: NSNull)
    case unknown(_ value: Any)

    public func value() -> Any {
        switch self {
        case let .number(value):
            return value
        case let .string(value):
            return value
        case let .bool(value):
            return value
        case let .array(value):
            return value
        case let .dictionary(value):
            return value
        case let .null(value):
            return value
        case let .unknown(value):
            return value
        }
    }

    public init(_ value: Any) {
        switch value {
        case let value as NSNumber:
            self = .number(value)
        case let value as String:
            self = .string(value)
        case let value as Bool:
            self = .bool(value)
        case let value as [Any]:
            self = .array(value)
        case let value as [String: Any]:
            self = .dictionary(value)
        case let value as NSNull:
            self = .null(value)
        default:
            self = .unknown(value)
        }
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            if let dictionary = try? container.decode([String: Any].self) {
                self = .dictionary(dictionary)
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                        debugDescription: "AnyCodable value cannot be decoded"))
            }
            return
        }

        if var container = try? decoder.unkeyedContainer() {
            if let array = try? container.decode([Any].self) {
                self = .array(array)
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
            }
            return
        }

        if let container = try? decoder.singleValueContainer() {
            if container.decodeNil() {
                self = .null(NSNull())

            } else if let string = try? container.decode(String.self) {
                self = .string(string)

            } else if let bool = try? container.decode(Bool.self) {
                self = .bool(bool)

            } else if let int = try? container.decode(Int.self) {
                self = .number(int as NSNumber)

            } else if let double = try? container.decode(Double.self) {
                self = .number(double as NSNumber)

            } else {
                throw DecodingError.dataCorruptedError(in: container,
                                                       debugDescription: "AnyCodable value cannot be decoded")
            }
            return
        }

        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Could not initialize container"))
    }
}
