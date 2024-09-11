//
//  GreaterThanOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

@testable import SwiftRuleEngine
import XCTest

class GreaterThanOperatorTests: XCTestCase {
    func testIntsMatch() {
        let op = try! GreaterThan(value: .number(99), params: nil)
        let rhs: Any = 100

        XCTAssertTrue(op.match(rhs))
    }

    func testIntsNotMatch() {
        let op = try! GreaterThan(value: .number(100), params: nil)
        let rhs: Any = 99

        XCTAssertFalse(op.match(rhs))
    }

    func testDoublesMatch() {
        let op = try! GreaterThan(value: .number(100.11), params: nil)
        let rhs: Any = 100.13

        XCTAssertTrue(op.match(rhs))
    }

    func testDoublesNotMatch() {
        let op = try! GreaterThan(value: .number(100.13), params: nil)
        let rhs: Any = 100.11

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! GreaterThan(value: .string("t"), params: nil)
        let rhs: Any = "test_test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! GreaterThan(value: .string("test_test"), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        let op = try! GreaterThan(value: .bool(true), params: nil)
        let rhs: Any = false

        XCTAssertFalse(op.match(rhs))
    }
}
