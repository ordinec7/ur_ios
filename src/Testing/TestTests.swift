//
//  TestTests.swift
//  TestTests
//
//  Created by Anton on 7/19/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import XCTest
@testable import ur

class TestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testTest() {
        let appDelegate = AppDelegate()
        XCTAssertEqual("azaza", appDelegate.testThing(2))
        XCTAssertEqual("azazazazaza", appDelegate.testThing(5))
        XCTAssertNil(appDelegate.testThing(-1))
        XCTAssertNil(appDelegate.testThing(Int.min))
        XCTAssertNotNil(appDelegate.testThing(1000))
        XCTAssertEqual("a", appDelegate.testThing(0))
        XCTAssertTrue(appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: [:]))
    }
}
