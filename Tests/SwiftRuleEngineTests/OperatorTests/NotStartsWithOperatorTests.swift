//
//  NotStartsWithOperatorTests.swift
//
//
//  Created by Santiago Alvarez on 21/12/2023.
//

@testable import SwiftRuleEngine
import XCTest

final class NotStartsWithOperatorTests: XCTestCase {
    func testMatch() {
        let op = try! NotStartsWith(value: .string("hello"), params: nil)

        XCTAssertTrue(op.match("¡hello_world"))
    }

    func testNoMatch() {
        let op = try! NotStartsWith(value: .string("hello"), params: nil)

        XCTAssertFalse(op.match("hello_world!"))
    }

    func testNoMatchTypeMismatch() {
        let op = try! NotStartsWith(value: .string("hello"), params: nil)

        XCTAssertFalse(op.match(123))
    }
}
