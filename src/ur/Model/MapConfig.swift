//
//  MapConfig.swift
//  ur
//
//  Created by MSQUARDIAN on 7/18/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation

struct MapConfig {
    let height: Int
    let width: Int
    let highgroundsCells: Set<Cell>
    let path: [Int: [Cell]]
}

struct Cell: Hashable, Equatable, Codable {
    let x: Int
    let y: Int
}

