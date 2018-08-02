//
//  DiceTests.swift
//  ur-Tests
//
//  Created by Anton on 8/1/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import XCTest
@testable import ur

class DiceTests: XCTestCase {
    
    func testDice() {
        let cases: [(minVal: Int, maxVal: Int)] = [
            (0, 1),
            (-10, 10),
            (0, 50)
        ]
        
        let triesCount = 10000
        
        for (minVal, maxVal) in cases {
            let dice = Dice(lowest: minVal, highest: maxVal)
            var results: [Int] = []
            for _ in 0..<triesCount {
                let next = dice.next()
                results.append(next)
                XCTAssertGreaterThanOrEqual(next, minVal)
                XCTAssertLessThanOrEqual(next, maxVal)
            }
            XCTAssertTrue(results.contains(minVal))
            XCTAssertTrue(results.contains(maxVal))
        }
        
    }
    
}
