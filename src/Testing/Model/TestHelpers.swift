//
//  TestHelpers.swift
//  ur-Tests
//
//  Created by Anton on 7/27/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import XCTest

infix operator <=>
func <=><T>(_ left: @autoclosure ()->T, _ right: @autoclosure ()->T) where T:Equatable {
    XCTAssertEqual(left(), right())
}

func <=><T>(_ left: @autoclosure ()->T?, _ right: @autoclosure ()->T?) where T:Equatable {
    switch (left(), right()) {
    case (.none, .none):
        break
    case (.some(let l), .none):
        XCTFail("Expected: nil, actual: \(l)")
    case (.none, .some(let r)):
        XCTFail("Expected: \(r), actual: nil")
    case (.some(let l), .some(let r)):
        XCTAssertEqual(l, r)
    }
}
