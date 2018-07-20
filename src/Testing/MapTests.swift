//
//  MapTests.swift
//  ur-Tests
//
//  Created by Anton on 7/20/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import XCTest
@testable import ur

class MapTests: XCTestCase {
    
    let smallMap = Map(config: MapConfigModels.small)
    let twoPlayersMap = Map(config: MapConfigModels.twoPlayersSmall)
    let hugePathMap = Map(config: MapConfigModels.hugePath)
    
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
    }
    
    
    func testMapInit() {
        for config in [MapConfigModels.small, MapConfigModels.twoPlayersSmall] {
            let map = Map(config: config)
            XCTAssertEqual(map.config.highgroundsCells, config.highgroundsCells)
            XCTAssertEqual(map.config.path, config.path)
            XCTAssertEqual(map.config.height, config.height)
            XCTAssertEqual(map.config.width, config.width)
        }
    }
    
    
    func testValidCells() {
        XCTAssertEqual(smallMap.validCells, ["0;0", "1;0", "0;1", "1;1"])
        XCTAssertEqual(twoPlayersMap.validCells, ["0;0", "1;0", "2;0", "3;0", "3;1", "3;2", "3;3", "2;3", "1;3", "0;3", "0;2", "0;1"])
    }
    
    
    func testHighground() {
        XCTAssertFalse(smallMap.isHighground(cell: "0;0"))
        XCTAssertFalse(smallMap.isHighground(cell: "1;1"))
        XCTAssertFalse(smallMap.isHighground(cell: "2;2"))
        XCTAssertTrue(twoPlayersMap.isHighground(cell: "0;3"))
        XCTAssertTrue(twoPlayersMap.isHighground(cell: "3;0"))
        XCTAssertFalse(twoPlayersMap.isHighground(cell: "0;0"))
        XCTAssertFalse(twoPlayersMap.isHighground(cell: "2;2"))
    }
    
    
    func testPathFind() {
        XCTAssertEqual(smallMap.movePath(from: "0.0", with: 1, player: 1), .invalid, "Expected invalid result since player 1 has no path")
        XCTAssertEqual(smallMap.movePath(from: "2.2", with: 1, player: 0), .invalid, "Expected invalid result since cell 2:2 does not exist")
        XCTAssertEqual(smallMap.movePath(from: "0.0", with: 100, player: 0), .invalid, "Expected invalid result since step is larger then map")
        XCTAssertEqual(smallMap.movePath(from: "0.0", with: -2, player: 0), .invalid, "Expected invalid result since step is negative")
        XCTAssertEqual(smallMap.movePath(from: "0.0", with: 0, player: 0), .invalid, "Expected invalid result since step is zero")
        
        XCTAssertEqual(smallMap.movePath(from: "0.0", with: 3, player: 0), .valid(["0.1", "1.1", "1.0"]))
        XCTAssertEqual(smallMap.movePath(from: "0.0", with: 4, player: 0), .exit(["0.1", "1.1", "1.0"]))
        XCTAssertEqual(smallMap.movePath(from: "1.0", with: 1, player: 0), .exit([]))
        XCTAssertEqual(smallMap.movePath(from: "1.0", with: 2, player: 0), .invalid)
        XCTAssertEqual(smallMap.movePath(from: "1.1", with: 2, player: 0), .exit(["1.0"]))
        XCTAssertEqual(smallMap.movePath(from: "1.1", with: 1, player: 0), .valid(["1.0"]))
        
        XCTAssertEqual(twoPlayersMap.movePath(from: "0.0", with: 1, player: 2), .invalid, "Expected invalid result since player 2 has no path")
        XCTAssertEqual(twoPlayersMap.movePath(from: "0.3", with: 1, player: 1), .invalid, "Expected invalid result since path of player 1 does not go through cell 0:3")
        XCTAssertEqual(twoPlayersMap.movePath(from: "3.0", with: 1, player: 1), .invalid, "Expected invalid result since path of player 0 does not go through cell 3:0")
        
        XCTAssertEqual(twoPlayersMap.movePath(from: "0.0", with: 1, player: 0), .valid(["0.1"]))
        XCTAssertEqual(twoPlayersMap.movePath(from: "0.0", with: 6, player: 0), .valid(["0.1", "0.2", "0.3", "1.3", "2.3", "3.3"]))
        XCTAssertEqual(twoPlayersMap.movePath(from: "0.0", with: 7, player: 0), .exit(["0.1", "0.2", "0.3", "1.3", "2.3", "3.3"]))
        
        XCTAssertEqual(twoPlayersMap.movePath(from: "1.3", with: 2, player: 0), .valid(["0.1", "0.2", "0.3", "1.3", "2.3", "3.3"]))
        XCTAssertEqual(twoPlayersMap.movePath(from: "1.3", with: 3, player: 0), .exit(["0.1", "0.2", "0.3", "1.3", "2.3", "3.3"]))
        XCTAssertEqual(twoPlayersMap.movePath(from: "1.3", with: 4, player: 0), .invalid)
        
        XCTAssertEqual(twoPlayersMap.movePath(from: "2.2", with: 1, player: 0), .invalid)
        XCTAssertEqual(twoPlayersMap.movePath(from: "2.2", with: 1, player: 1), .invalid)
        XCTAssertEqual(twoPlayersMap.movePath(from: "2.2", with: 1, player: 2), .invalid)
        
        for _ in 0..<5 {
            let stepSize = Int(arc4random_uniform(5000))
            let startPoint = Cell(x: Int(arc4random_uniform(40)), y: Int(arc4random_uniform(40)))
            let pathSearchResult = hugePathMap.movePath(from: startPoint, with: stepSize, player: 0)
            guard case let .valid(path) = pathSearchResult else {
                XCTFail("Expected path with size \(stepSize) starting on \(startPoint) to be valid on a map with max path lenght 10000. Actual result: \(pathSearchResult)")
                continue
            }
            XCTAssertEqual(path.count, stepSize, "Expected valid path to be of length equal to step size")
        }
    }
    
}
