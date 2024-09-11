//
//  RuleEngine.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

enum RuleEngineError: Error {
    case operatorNotFound
    case duplicateOperator
    case invalidRule(String)
}

public final class RuleEngine {
    private var rules: [Rule] = []
    private let ruleDecoder: RuleDecoder

    public init(rules: [String], customOperators: [Operator.Type] = []) throws {
        ruleDecoder = try RuleDecoder(customOperators)
        self.rules = rules.compactMap { dictRule in
            try? decodeRule(rule: dictRule)
        }
    }

    public init(rules: [[String: Any]], customOperators: [Operator.Type] = []) throws {
        ruleDecoder = try RuleDecoder(customOperators)
        self.rules = rules.compactMap { dictRule in
            try? decodeRule(rule: dictRule)
        }
    }

    public init(rules: [Rule], customOperators: [Operator.Type] = []) throws {
        ruleDecoder = try RuleDecoder(customOperators)
        self.rules = rules
    }

    private func decodeRule(rule: [String: Any]) throws -> Rule {
        guard let ruleData = try? JSONSerialization.data(withJSONObject: rule, options: []) else {
            throw RuleEngineError.invalidRule("Error converting dict to data")
        }

        guard let rule = try? ruleDecoder.decode(Rule.self, from: ruleData) else {
            throw RuleEngineError.invalidRule("Error decoding rule")
        }
        return rule
    }

    private func decodeRule(rule: String) throws -> Rule {
        guard let ruleData = rule.data(using: .utf8) else {
            throw RuleEngineError.invalidRule("Rule not in utf8 format")
        }

        guard let rule = try? ruleDecoder.decode(Rule.self, from: ruleData) else {
            throw RuleEngineError.invalidRule("Error decoding rule")
        }
        return rule
    }

    public func evaluate(_ obj: Any) -> Rule? {
        let sortedRules = rules.sorted { $0.priority > $1.priority }
        for rule in sortedRules {
            var rule = rule
            guard (try? rule.conditions.evaluate(obj)) != nil else {
                continue
            }
            if rule.conditions.match {
                return rule
            }
        }
        return nil
    }
}
