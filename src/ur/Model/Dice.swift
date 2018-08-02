//
//  Dice.swift
//  ur
//
//  Created by Anton on 7/27/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import GameplayKit


/// Set of dices
struct DiceSet {
    
    private let dices: [Dice]
    
    /// Roll next dice values
    func next() -> [Int] {
        return dices.map { $0.next() }
    }
    
    static func urSet(randomSource: GKRandom = GKRandomSource.sharedRandom(), count: Int = 4) -> DiceSet {
        let dices = Array(repeating: Dice.urDice(randomSource), count: count)
        return self.init(dices: dices)
    }
}


struct Dice {
    
    private let random: GKRandomDistribution
    
    var lowestValue: Int { return random.lowestValue }
    var highestValue: Int { return random.highestValue }
    
    func next() -> Int {
        return random.nextInt()
    }

    init(lowest: Int, highest: Int, randomSource: GKRandom = GKRandomSource.sharedRandom()) {
        self.random = GKRandomDistribution(randomSource: randomSource, lowestValue: lowest, highestValue: highest)
    }
}


extension Dice {
    static func urDice(_ random: GKRandom) -> Dice {
        return self.init(lowest: 0, highest: 1, randomSource: random)
    }
}
