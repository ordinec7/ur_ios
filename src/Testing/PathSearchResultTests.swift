//
//  PathSearchResultTests.swift
//  ur-Tests
//
//  Created by Anton on 8/1/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import XCTest
@testable import ur

class PathSearchResultTests: XCTestCase {
    
    func testOnPathProperties() {
        let hugeMap = Map(config: MapConfigModels.hugePath)
        
        for _ in 0..<10000 {
            let startPosition = PathPosition.onPath(Int(arc4random_uniform(20000)))
            let stepSize = Int(arc4random_uniform(10000))
            
            guard let psr = hugeMap.findPath(from: startPosition, withStep: stepSize, player: 0) else {
                continue
            }
            XCTAssertEqual(psr.startPosition, startPosition)
            XCTAssertEqual(psr.path.first, psr.startCell)
            if case let .onPath(index) = psr.finalPosition {
                XCTAssertEqual(index, startPosition.value! + stepSize)
                XCTAssertEqual(psr.path.last, psr.finalCell)
            }
        }
    }
    
    func testInitialization() {
        let path: [Cell] = ["0.0", "10.0", "0.10", "10.10"]
        let startCell: Cell = "0.0"
        let finalCell: Cell = "10.10"
        let startPos = PathPosition.onPath(10)
        let finalPos = PathPosition.onPath(300)
        
        let psr1 = PathSearchResult(path, startPos, finalPos)
        XCTAssertEqual(psr1.path, path)
        XCTAssertEqual(psr1.startPosition, startPos)
        XCTAssertEqual(psr1.finalPosition, finalPos)
        XCTAssertEqual(psr1.startCell, startCell)
        XCTAssertEqual(psr1.finalCell, finalCell)
        
        let psr2 = PathSearchResult(path, .start, finalPos)
        XCTAssertEqual(psr2.path, path)
        XCTAssertEqual(psr2.startPosition, .start)
        XCTAssertEqual(psr2.finalPosition, finalPos)
        XCTAssertEqual(psr2.startCell, nil)
        XCTAssertEqual(psr2.finalCell, finalCell)
        
        let psr3 = PathSearchResult(path, startPos, .exit)
        XCTAssertEqual(psr3.path, path)
        XCTAssertEqual(psr3.startPosition, startPos)
        XCTAssertEqual(psr3.finalPosition, .exit)
        XCTAssertEqual(psr3.startCell, startCell)
        XCTAssertEqual(psr3.finalCell, nil)
        
        let psr4 = PathSearchResult(path, .start, .exit)
        XCTAssertEqual(psr4.path, path)
        XCTAssertEqual(psr4.startPosition, .start)
        XCTAssertEqual(psr4.finalPosition, .exit)
        XCTAssertEqual(psr4.startCell, nil)
        XCTAssertEqual(psr4.finalCell, nil)
        
        let psr5 = PathSearchResult(path, .exit, .start)
        XCTAssertEqual(psr5.path, path)
        XCTAssertEqual(psr5.startPosition, .exit)
        XCTAssertEqual(psr5.finalPosition, .start)
        XCTAssertEqual(psr5.startCell, nil)
        XCTAssertEqual(psr5.finalCell, nil)
    }
    
}
