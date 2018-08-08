//
//  GameRulesTestModel.swift
//  ur-Tests
//
//  Created by MSQUARDIAN on 8/6/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation
@testable import ur

enum GameRulesModels {
    /// One rock, standart dice set
    static let smallMapOnePlayer = GameRules(identifier: "small", rocksCount: 1, diceSet: DiceSet.urSet(), mapConfig: MapConfigModels.small)

    /// 4 rocks, standart dice set
    static let twoPlayersSmall = GameRules(identifier: "notSoSmall", rocksCount: 2, diceSet: DiceSet.urSet(), mapConfig: MapConfigModels.twoPlayersSmall)

    /// One rock, 2 dices
    static let huge = GameRules(identifier: "huge", rocksCount: 1, diceSet: DiceSet.urSet(count: 2), mapConfig: MapConfigModels.hugePath)
}
