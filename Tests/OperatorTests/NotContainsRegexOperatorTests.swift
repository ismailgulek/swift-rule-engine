//
//  NotContainsRegexOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 04/04/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class NotContainsRegexOperatorTests: XCTestCase {

    func testStringArrayMatch() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^/Users/.*/Desktop/hello.txt$"),
                             valueType: .regex)
        let condition = SimpleCondition(op: .not_contains_regex, value: lhs)
        let rhs: Any = ["/Users/messi/Library/hello.txt"]

        let op = NotContainsRegex()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testStringArrayMatch2() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^/Users/.*/Desktop/hello.txt$"),
                             valueType: .regex)
        let condition = SimpleCondition(op: .not_contains_regex, value: lhs)
        let rhs: Any = ["/Users/messi/Documents/hello.txt", "/Users/messi/Library/hello.txt"]

        let op = NotContainsRegex()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testStringArrayNotMatch() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^/Users/.*/Desktop/hello.txt$"),
                             valueType: .regex)
        let condition = SimpleCondition(op: .not_contains_regex, value: lhs)
        let rhs: Any = ["/Users/messi/Desktop/hello.txt"]

        let op = NotContainsRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testStringArrayNotMatch2() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^/Users/.*/Desktop/hello.txt$"),
                             valueType: .regex)
        let condition = SimpleCondition(op: .not_contains_regex, value: lhs)
        let rhs: Any = ["/Users/messi/Documents/hello.txt", "/Users/messi/Desktop/hello.txt"]

        let op = NotContainsRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

}
