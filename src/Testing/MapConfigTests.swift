//
//  MapConfigTests.swift
//  ur-Tests
//
//  Created by Anton on 7/20/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

@testable import ur
import XCTest

class MapConfigTests: XCTestCase {

    func testSmallMapData() {
        let mapConfig = MapConfigModels.small
        XCTAssertTrue(mapConfig.highgroundsCells.isEmpty)
        XCTAssertEqual(Set(mapConfig.path.keys), Set([0]))
        XCTAssertEqual(mapConfig.path[0]?.count, 4)
        XCTAssertEqual(mapConfig.path[0], [Cell(x: 0, y: 0), Cell(x: 0, y: 1), Cell(x: 1, y: 1), Cell(x: 1, y: 0)])
    }

}
