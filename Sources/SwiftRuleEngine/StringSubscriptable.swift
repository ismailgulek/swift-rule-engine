//
//  StringSubscriptable.swift
//
//
//  Created by Santiago Alvarez on 15/06/2024.
//

import Foundation

public protocol StringSubscriptable {
    associatedtype Value

    subscript(_: String) -> Value? { get }
}
