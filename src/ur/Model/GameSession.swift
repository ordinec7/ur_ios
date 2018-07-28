//
//  GameSession.swift
//  ur
//
//  Created by Anton on 7/27/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation

protocol GameSessionDelegate: class {
    func player(_ player: Int, cantMakeHisMoveInSession: GameSession)
}

class GameSession {
    
    weak var delegate: GameSessionDelegate?
    
    let gameRules: GameRules
    let dices: DiceSet
    let map: Map
    let players: [Int]
    
    var moveState: MoveState
    var rocksPositions: [Int: [PathPosition]]
    var currentPlayerIndex: Int
    var dicesTrow: [Int] = []
    
    var currentPlayer: Int { return players[currentPlayerIndex] }
    var stepSize: Int { return dicesTrow.reduce(0, +) }
    
    func throwDices() -> [Int] {
        guard moveState == .idling else {
            preconditionFailure("Cant throw new dices before making or skipping a move with previous throw")
        }
        dicesTrow = dices.next()
        if hasMoves {
            moveState = .makingMove
        } else {
            delegate?.player(currentPlayer, cantMakeHisMoveInSession: self)
            selectNextPlayer()
            moveState = .idling
        }
        return dicesTrow
    }
    
    func selectNextPlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    var hasMoves: Bool {
        let stepSize = self.stepSize
        guard stepSize > 0 else {
            return false
        }
        
        let pathes = rocksPositions[currentPlayer]!.compactMap{
            map.findPath(from: $0, withStep: stepSize, player: currentPlayer)
        }
        return pathes.count > 0
    }
    
    init(rules: GameRules) {
        gameRules = rules
        map = Map(config: rules.mapConfig)
        dices = rules.diceSet
        players = map.players.sorted()
        
        rocksPositions = [:]
        for player in players {
            rocksPositions[player] = Array(repeating: .start, count: rules.rocksCount)
        }
        
        moveState = .idling
        currentPlayerIndex = 0
    }
}

enum MoveState: Equatable {
    case makingMove
    case idling
}
