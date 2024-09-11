//
//  SimpleConditionTests.swift
//
//
//  Created by Santiago Alvarez on 27/12/2023.
//

@testable import SwiftRuleEngine
import XCTest

final class SimpleConditionTests: XCTestCase {
    private var decoder: RuleDecoder!

    override func setUp() {
        decoder = try! RuleDecoder()
    }

    func testModeWithInvalidValue() {
        let cond = """
        {"value": "hello", "operator": "contains", "params": {"mode": "any"}}
        """
        // This should fail as value is not an array
        XCTAssertThrowsError(try decoder.decode(SimpleCondition.self, from: cond.data(using: .utf8)!))
    }

    func testModeAnyWithContainsMatch() throws {
        let cond = """
        {"value": ["hello", "world"], "operator": "contains", "params": {"mode": "any"}}
        """

        var s = try decoder.decode(SimpleCondition.self, from: cond.data(using: .utf8)!)

        try s.evaluate(["hi", "hola", "world"])
        XCTAssertTrue(s.match)
    }

    func testModeAnyWithContainsNoMatch() throws {
        let cond = """
        {"value": ["hello", "world"], "operator": "contains", "params": {"mode": "any"}}
        """

        var s = try decoder.decode(SimpleCondition.self, from: cond.data(using: .utf8)!)

        try s.evaluate(["hi", "hola", "some", "holis"])
        XCTAssertFalse(s.match)
    }

    func testModeAllWithContainsMatch() throws {
        let cond = """
        {"value": ["hello", "world"], "operator": "contains", "params": {"mode": "all"}}
        """

        var s = try decoder.decode(SimpleCondition.self, from: cond.data(using: .utf8)!)

        try s.evaluate(["hi", "hello", "world"])
        XCTAssertTrue(s.match)
    }

    func testModeAllWithContainsNoMatch() throws {
        let cond = """
        {"value": ["hello", "world"], "operator": "contains", "params": {"mode": "all"}}
        """

        var s = try decoder.decode(SimpleCondition.self, from: cond.data(using: .utf8)!)

        try s.evaluate(["hi", "hola", "some", "holis"])
        XCTAssertFalse(s.match)
    }
}
