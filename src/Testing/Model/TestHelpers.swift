//
//  TestHelpers.swift
//  ur-Tests
//
//  Created by Anton on 7/27/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import XCTest

infix operator <=>
func <=> <T>(_ left: @autoclosure () -> T, _ right: @autoclosure () -> T) where T: Equatable {
    XCTAssertEqual(left(), right())
}

func <=> <T>(_ left: @autoclosure () -> T?, _ right: @autoclosure () -> T?) where T: Equatable {
    switch (left(), right()) {
    case (.none, .none):
        break
    case (.some(let lhs), .none):
        XCTFail("Expected: nil, actual: \(lhs)")
    case (.none, .some(let rhs)):
        XCTFail("Expected: \(rhs), actual: nil")
    case let (.some(lhs), .some(rhs)):
        XCTAssertEqual(lhs, rhs)
    }
}
