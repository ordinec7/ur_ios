//
//  MapTests.swift
//  ur-Tests
//
//  Created by Anton on 7/20/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

@testable import ur
import XCTest

class MapTests: XCTestCase {

    typealias PSR = PathSearchResult

    let smallMap = Map(config: MapConfigModels.small)
    let twoPlayersMap = Map(config: MapConfigModels.twoPlayersSmall)
    let hugePathMap = Map(config: MapConfigModels.hugePath)
    let zeroMap = Map(config: MapConfigModels.zero)

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
    }

    func testMapInit() {
        for config in [MapConfigModels.small, MapConfigModels.twoPlayersSmall] {
            let map = Map(config: config)
            XCTAssertEqual(map.config.highgroundsCells, config.highgroundsCells)
            XCTAssertEqual(map.config.path, config.path)
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

    func testPathFindOutOfBoundsValues() {
        XCTAssertNil(smallMap.findPath(from: 0, withStep: 1, player: 1), "Expected invalid result since player 1 has no path")
        XCTAssertNil(smallMap.findPath(from: 0, withStep: 1, player: -1000), "Expected invalid result since player -1000 has no path")

        XCTAssertNil(smallMap.findPath(from: 300, withStep: 1, player: 0), "Expected invalid result since path position is out of bounds")
        XCTAssertNil(smallMap.findPath(from: -5000, withStep: 1, player: 0), "Expected invalid result since path position is out of bounds")
        XCTAssertNil(smallMap.findPath(from: 4, withStep: 1, player: 0), "Expected invalid result since path position is out of bounds")
        XCTAssertNil(smallMap.findPath(from: .exit, withStep: 1, player: 0), "Expected invalid result since path position is the finish of the path")

        XCTAssertNil(smallMap.findPath(from: 0, withStep: 100, player: 0), "Expected invalid result since step is larger then map")
        XCTAssertNil(smallMap.findPath(from: .onPath(Int.max), withStep: 100000, player: 0), "Expected invalid result since step is larger then map")
        XCTAssertNil(smallMap.findPath(from: 0, withStep: 100000, player: 0), "Expected invalid result since step is larger then map")
        XCTAssertNil(smallMap.findPath(from: 0, withStep: -1, player: 0), "Expected invalid result since step is negative")
        XCTAssertNil(smallMap.findPath(from: 0, withStep: Int.min, player: 0), "Expected invalid result since step is negative")
        XCTAssertNil(smallMap.findPath(from: 0, withStep: 0, player: 0), "Expected invalid result since step is zero")
    }

    func testPathReasonableValues() {

        // Small map

        XCTAssertEqual(smallMap.findPath(from: .start, withStep: 1, player: 0), PSR(["0.0"], .start, 0))
        XCTAssertEqual(smallMap.findPath(from: .start, withStep: 2, player: 0), PSR(["0.0", "0.1"], .start, 1))
        XCTAssertEqual(smallMap.findPath(from: .start, withStep: 4, player: 0), PSR(["0.0", "0.1", "1.1", "1.0"], .start, 3))
        XCTAssertEqual(smallMap.findPath(from: .start, withStep: 5, player: 0), PSR(["0.0", "0.1", "1.1", "1.0"], .start, .exit))
        XCTAssertEqual(smallMap.findPath(from: .start, withStep: 6, player: 0), PSR?.none)

        XCTAssertEqual(smallMap.findPath(from: 0, withStep: 3, player: 0), PSR(["0.0", "0.1", "1.1", "1.0"], 0, 3))
        XCTAssertEqual(smallMap.findPath(from: 0, withStep: 4, player: 0), PSR(["0.0", "0.1", "1.1", "1.0"], 0, .exit))
        XCTAssertEqual(smallMap.findPath(from: 3, withStep: 1, player: 0), PSR(["1.0"], 3, .exit))
        XCTAssertEqual(smallMap.findPath(from: 3, withStep: 2, player: 0), PSR?.none)
        XCTAssertEqual(smallMap.findPath(from: 2, withStep: 2, player: 0), PSR(["1.1", "1.0"], 2, .exit))
        XCTAssertEqual(smallMap.findPath(from: 2, withStep: 1, player: 0), PSR(["1.1", "1.0"], 2, 3))

        // Two players map

        XCTAssertEqual(twoPlayersMap.findPath(from: .start, withStep: 1, player: 0), PSR(["0.0"], .start, 0))
        XCTAssertEqual(twoPlayersMap.findPath(from: 0, withStep: 1, player: 0), PSR(["0.0", "0.1"], 0, 1))
        XCTAssertEqual(twoPlayersMap.findPath(from: 0, withStep: 6, player: 0), PSR(["0.0", "0.1", "0.2", "0.3", "1.3", "2.3", "3.3"], 0, 6))
        XCTAssertEqual(twoPlayersMap.findPath(from: 0, withStep: 7, player: 0), PSR(["0.0", "0.1", "0.2", "0.3", "1.3", "2.3", "3.3"], 0, .exit))
        XCTAssertEqual(twoPlayersMap.findPath(from: 0, withStep: 8, player: 0), PSR?.none)
        XCTAssertEqual(twoPlayersMap.findPath(from: .start, withStep: 8, player: 0), PSR(["0.0", "0.1", "0.2", "0.3", "1.3", "2.3", "3.3"], .start, .exit))

        XCTAssertEqual(twoPlayersMap.findPath(from: 4, withStep: 2, player: 0), PSR(["1.3", "2.3", "3.3"], 4, 6))
        XCTAssertEqual(twoPlayersMap.findPath(from: 4, withStep: 3, player: 0), PSR(["1.3", "2.3", "3.3"], 4, .exit))
        XCTAssertEqual(twoPlayersMap.findPath(from: 4, withStep: 4, player: 0), PSR?.none)

        XCTAssertEqual(twoPlayersMap.findPath(from: 4, withStep: 1, player: 1), PSR(["2.0", "1.0"], 4, 5))
        XCTAssertEqual(twoPlayersMap.findPath(from: .start, withStep: 1, player: 1), PSR(["3.3"], .start, 0))
        XCTAssertEqual(twoPlayersMap.findPath(from: 6, withStep: 1, player: 1), PSR(["0.0"], 6, .exit))
        XCTAssertEqual(twoPlayersMap.findPath(from: 6, withStep: 2, player: 1), PSR?.none)
        XCTAssertEqual(twoPlayersMap.findPath(from: .start, withStep: 8, player: 1), PSR(["3.3", "3.2", "3.1", "3.0", "2.0", "1.0", "0.0"], .start, .exit))

    }
}
