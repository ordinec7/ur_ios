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
            XCTAssertEqual(dice.highestValue, maxVal)
            XCTAssertEqual(dice.lowestValue, minVal)
            
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
    
    func testRandomSource() {
        let always115 = Dice(lowest: 100, highest: 200, randomSource: SingleValueRandom(15))
        let always0 = Dice(lowest: 0, highest: 200, randomSource: SingleValueRandom(0))
        let zeroThroughTen = Dice(lowest: 0, highest: 10, randomSource: SequenceRandom(lower: 0, upper: 100))
        let zeroThroughTen2 = Dice(lowest: -100, highest: 100, randomSource: SequenceRandom(lower: 100, upper: 110))
        let blinkingUr = Dice.urDice(SequenceRandom())
        
        for i in 0..<100 {
            XCTAssertEqual(always115.next(), 115)
            XCTAssertEqual(always0.next(), 0)
            XCTAssertEqual(zeroThroughTen.next(), i % 11)
            XCTAssertEqual(zeroThroughTen2.next(), i % 11)
            XCTAssertEqual(blinkingUr.next(), i % 2)
        }
    }
    
    func testRandomSourceForSet() {
        let always0 = DiceSet.urSet(randomSource: SingleValueRandom(0), count: 3)
        let always1 = DiceSet.urSet(randomSource: SingleValueRandom(1), count: 5)
        let blinking = DiceSet.urSet(randomSource: SequenceRandom(), count: 4)
        
        for _ in 0..<100 {
            XCTAssertEqual(always0.next(), [0, 0, 0])
            XCTAssertEqual(always1.next(), [1, 1, 1, 1, 1])
            XCTAssertEqual(blinking.next(), [0, 1, 0, 1])
        }
    }
    
}
