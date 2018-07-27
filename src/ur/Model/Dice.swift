//
//  Dice.swift
//  ur
//
//  Created by Anton on 7/27/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import GameplayKit


protocol Dice {
    associatedtype RandomResult
    func next() -> RandomResult
}


protocol DiceSet {
    associatedtype DiceType: Dice
    func next() -> [DiceType.RandomResult]
}


struct UrDiceSet: DiceSet {
    typealias DiceType = UrDice
    
    private let dices: [UrDice]
    
    func next() -> [Int] {
        return dices.map { $0.next() }
    }
    
    init(randomSource: GKRandom = GKRandomSource.sharedRandom(), count: Int = 4) {
        self.dices = Array.init(repeating: UrDice(randomSource: randomSource), count: count)
    }
    
}


struct UrDice: Dice {
    typealias RandomResult = Int
    
    private let random: GKRandomDistribution
    
    func next() -> Int {
        return random.nextInt()
    }

    init(randomSource: GKRandom = GKRandomSource.sharedRandom()) {
        self.random = GKRandomDistribution(randomSource: randomSource, lowestValue: 0, highestValue: 1)
    }
}
