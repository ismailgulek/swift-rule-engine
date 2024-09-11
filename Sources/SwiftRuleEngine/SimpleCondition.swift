//
//  SimpleCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation

public struct SimpleCondition: Condition {
    public var match: Bool = false
    public let op: [Operator]
    public let value: AnyCodable
    public let params: [String: Any]?
    public let fact: String?
    public let path: JSONPath?

    private let mode: Mode?

    public mutating func evaluate(_ obj: Any) throws {
        let object = try extractObjectToBeEvaluated(from: obj)

        guard let mode else {
            match = op[0].match(object)
            return
        }

        match = evaluateMode(object, mode)
    }

    private func extractObjectToBeEvaluated(from obj: Any) throws -> Any {
        if let fact {
            if let dict = obj as? [String: Any] {
                return dict[fact] ?? obj
            } else {
                return obj
            }
        } else if let path {
            return try path.getValue(for: obj)
        } else {
            return obj
        }
    }

    private func evaluateMode(_ obj: Any, _ mode: Mode) -> Bool {
        switch mode {
        case .any:
            return op.contains { $0.match(obj) }
        case .all:
            return op.allSatisfy { $0.match(obj) }
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        params = try? container.decode([String: Any].self, forKey: .params)
        value = try container.decode(AnyCodable.self, forKey: .value)
        if let modeStr = params?["mode"] as? String {
            mode = Mode(rawValue: modeStr)
            if mode == nil {
                throw DecodingError.dataCorruptedError(forKey: .params, in: container,
                                                       debugDescription: "Invalid mode value")
            }
            // If mode is set then the value has to be an array
            if case .array = value {} else {
                throw DecodingError.dataCorruptedError(forKey: .value, in: container,
                                                       debugDescription: "Value should be an array when mode is specified")
            }
        } else {
            mode = nil
        }

        let operatorID = try container.decode(OperatorID.self, forKey: .op)
        guard let operatorsDict = decoder.userInfo[operatorsUserInfoKey] as? [OperatorID: Operator.Type] else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Operators user info key not provided")
        }
        guard let operatorType = operatorsDict[operatorID] else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Operator \(operatorID.rawValue) not found")
        }

        do {
            if mode == nil {
                op = try [operatorType.init(value: value, params: params)]
            } else {
                // Iterate value and initialize all operators
                var ops: [Operator] = []
                for v in value.value() as! [Any] {
                    try ops.append(operatorType.init(value: AnyCodable(v), params: params))
                }
                op = ops
            }
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Error initializing operator \(operatorID.rawValue)")
        }

        fact = try container.decodeIfPresent(String.self, forKey: .fact)

        guard let pathStr = try container.decodeIfPresent(String.self, forKey: .path) else {
            path = nil
            return
        }
        path = try JSONPath(pathStr)
    }

    public init(op: [Operator], value: AnyCodable, params: [String: Any]?, fact: String?, path: JSONPath?) {
        self.op = op
        self.value = value
        self.params = params
        self.fact = fact
        self.path = path
        if let modeStr = self.params?["mode"] as? String {
            mode = Mode(rawValue: modeStr)
        } else {
            mode = nil
        }
    }

    private enum CodingKeys: String, CodingKey {
        case op = "operator", value, params, fact, path
    }

    private enum Mode: String {
        case any
        case all
    }
}
