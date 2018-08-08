//
//  GameRules.swift
//  ur
//
//  Created by Anton on 7/28/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation

public struct GameRules: Equatable {
    let identifier: String
    let rocksCount: Int
    let diceSet: DiceSet
    let mapConfig: MapConfig
}
