//
//  StartsWithOperatorTests.swift
//
//
//  Created by Santiago Alvarez on 21/12/2023.
//

@testable import SwiftRuleEngine
import XCTest

final class StartsWithOperatorTests: XCTestCase {
    func testMatch() {
        let op = try! StartsWith(value: .string("hello"), params: nil)

        XCTAssertTrue(op.match("hello_world"))
    }

    func testNoMatch() {
        let op = try! StartsWith(value: .string("hello"), params: nil)

        XCTAssertFalse(op.match("¡hello_world!"))
    }

    func testNoMatchTypeMismatch() {
        let op = try! StartsWith(value: .string("hello"), params: nil)

        XCTAssertFalse(op.match(123))
    }
}
