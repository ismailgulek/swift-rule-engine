//
//  NotEqualOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine


class NotEqualOperatorTests: XCTestCase {

    func testStringsMatch() {
        let op = try! NotEqual(value: AnyCodable(value: "test", valueType: .string), params: nil)
        let rhs: Any = "not-test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! NotEqual(value: AnyCodable(value: "test", valueType: .string), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testBoolsMatch() {
        let op = try! NotEqual(value: AnyCodable(value: true, valueType: .bool), params: nil)
        let rhs: Any = false

        XCTAssertTrue(op.match(rhs))
    }

     func testBoolsNotMatch() {
        let op = try! NotEqual(value: AnyCodable(value: true, valueType: .bool), params: nil)
        let rhs: Any = true

        XCTAssertFalse(op.match(rhs))
    }

    func testIntsMatch() {
        let op = try! NotEqual(value: AnyCodable(value: 123, valueType: .number), params: nil)
        let rhs: Any = 321

        XCTAssertTrue(op.match(rhs))
    }

    func testIntsNotMatch() {
        let op = try! NotEqual(value: AnyCodable(value: 123, valueType: .number), params: nil)
        let rhs: Any = 123

        XCTAssertFalse(op.match(rhs))
    }

    func testDoublesMatch() {
        let op = try! NotEqual(value: AnyCodable(value: 123.123, valueType: .number), params: nil)
        let rhs: Any = 321.321

        XCTAssertTrue(op.match(rhs))
    }

    func testDoublesNotMatch() {
        let op = try! NotEqual(value: AnyCodable(value: 123.123, valueType: .number), params: nil)
        let rhs: Any = 123.123

        XCTAssertFalse(op.match(rhs))
    }

    func testDictionariesMatch() {
        let op = try! NotEqual(value: AnyCodable(value: ["foo": "test", "bar": 123] as [String : Any], valueType: .dictionary), params: nil)
        let rhs: Any = ["foo": "test", "bar": 321] as [String : Any]

        XCTAssertTrue(op.match(rhs))
    }

    func testDictionariesNotMatch() {
        let op = try! NotEqual(value: AnyCodable(value: ["foo": "test", "bar": 123] as [String : Any], valueType: .dictionary), params: nil)
        let rhs: Any = ["foo": "test", "bar": 123] as [String : Any]

        XCTAssertFalse(op.match(rhs))
    }

    func testArraysMatch() {
        let op = try! NotEqual(value: AnyCodable(value: ["foo", "bar"], valueType: .array), params: nil)
        let rhs: Any = ["foo"]

        XCTAssertTrue(op.match(rhs))
    }

    func testArraysNotMatch() {
        let op = try! NotEqual(value: AnyCodable(value: ["foo", "bar"], valueType: .array), params: nil)
        let rhs: Any = ["foo", "bar"]

        XCTAssertFalse(op.match(rhs))
    }

     func testMultiTypeArraysMatch() {
         let op = try! NotEqual(value: AnyCodable(value: ["foo", 123] as [Any], valueType: .array), params: nil)
         let rhs: Any = ["foo", 321] as [Any]

        XCTAssertTrue(op.match(rhs))
    }

    func testMultiTypeArraysNotMatch() {
        let op = try! NotEqual(value: AnyCodable(value: ["foo", 123] as [Any], valueType: .array), params: nil)
        let rhs: Any = ["foo", 123] as [Any]

        XCTAssertFalse(op.match(rhs))
    }

    func testNullsMatch() {
        let op = try! NotEqual(value: AnyCodable(value: NSNull(), valueType: .null), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testNullsNotMatch() {
        let op = try! NotEqual(value: AnyCodable(value: NSNull(), valueType: .null), params: nil)
        let rhs: Any = NSNull()

        XCTAssertFalse(op.match(rhs))
    }

}
