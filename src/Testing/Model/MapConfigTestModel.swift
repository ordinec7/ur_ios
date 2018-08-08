//
//  MapConfigTestModel.swift
//  ur-Tests
//
//  Created by Anton on 7/20/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation
@testable import ur

enum MapConfigModels {
    static let small = MapConfig(highgroundsCells: [], path: [
        0: ["0;0", "0;1", "1;1", "1;0"]
    ])

    static let twoPlayersSmall = MapConfig(highgroundsCells: ["0;3", "3;0"], path: [
        0: ["0;0", "0;1", "0;2", "0;3", "1;3", "2;3", "3;3"],
        1: ["3;3", "3;2", "3;1", "3;0", "2;0", "1;0", "0;0"]
    ])

    static let hugePath = MapConfig(highgroundsCells: [], path: [
        0: (0..<10000).map { Cell(x: $0 / 100, y: $0 % 100) }
    ])

    static let zero = MapConfig(highgroundsCells: [], path: [0: [], 1: []])
}
