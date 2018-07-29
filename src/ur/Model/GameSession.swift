//
//  GameSession.swift
//  ur
//
//  Created by Anton on 7/27/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation


protocol GameSessionDelegate: class {
    func player(_ player: Int, doesntHaveAnyMoveIn session: GameSession)
    func player(_ player: Int, isReadyToThrowDicesIn session: GameSession)
    func player(_ player: Int, isReadyToMakeAMoveIn session: GameSession)
    func player(_ player: Int, makesAdditionalTurnIn session: GameSession)
}


class GameSession {
    
    private enum MoveState: Equatable {
        case idling
        case makingMove(dices: [Int])
    }
    
    weak var delegate: GameSessionDelegate?
    
    let gameRules: GameRules
    let dices: DiceSet
    let map: Map
    let players: [Int]
    
    private var moveState: MoveState
    var rocksPositions: [Int: [PathPosition]]
    var currentPlayerIndex: Int
    
    var currentPlayer: Int { return players[currentPlayerIndex] }
    
    
    // MARK: - Move functions
    
    func throwDices() -> [Int] {
        guard case .idling = moveState else {
            preconditionFailure("Can't throw new dices before making or skipping a move with previous throw")
        }
        let dicesThrow = dices.next()
        if availableMoves.isEmpty == false {
            moveState = .makingMove(dices: dicesThrow)
            delegate?.player(currentPlayer, isReadyToMakeAMoveIn: self)
        } else {
            delegate?.player(currentPlayer, doesntHaveAnyMoveIn: self)
            passTurn()
        }
        return dicesThrow
    }
    
    
    func move(from position: PathPosition) {
        guard let move = findMove(from: position) else {
            preconditionFailure("Can't make a non-existant move")
        }
        let changeIndex = rocksPositions[currentPlayer]!.index(of: move.startPosition)!
        rocksPositions[currentPlayer]![changeIndex] = move.finalPosition
        
        if let finalCell = move.finalCell, map.isHighground(cell: finalCell) {
            makeAdditionalTurn()
        } else {
            passTurn()
        }
    }
    
    
    func passTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        moveState = .idling
        delegate?.player(currentPlayer, isReadyToThrowDicesIn: self)
    }
    
    func makeAdditionalTurn() {
        moveState = .idling
        delegate?.player(currentPlayer, makesAdditionalTurnIn: self)
        delegate?.player(currentPlayer, isReadyToThrowDicesIn: self)
    }
    
    
    // MARK: - Data properties
    
    var stepSize: Int? {
        return diceThrow?.reduce(0, +)
    }
    
    var diceThrow: [Int]? {
        guard case let .makingMove(dices: diceThrow) = moveState else {
            return nil
        }
        return diceThrow
    }
    
    
    var availableMoves: [PathSearchResult] {
        return rocksPositions[currentPlayer]!.compactMap { self.findMove(from: $0) }
    }
    
    
    func findMove(from position: PathPosition) -> PathSearchResult? {
        guard let stepSize = stepSize, stepSize > 0 else {
            return nil
        }
        guard rocksPositions[currentPlayer]!.contains(position) else {
            return nil
        }
        guard let path = map.findPath(from: position, withStep: stepSize, player: currentPlayer) else {
            return nil
        }
        if let finalCell = path.finalCell, occupiedCells(for: currentPlayer).contains(finalCell) {
            return nil
        }
        if let finalCell = path.finalCell, map.isHighground(cell: finalCell) {
            let otherPlayers = players.filter { $0 != currentPlayer }
            let otherPlayerRocks = occupiedCells(for: otherPlayers)
            if otherPlayerRocks.contains(finalCell) {
                return nil
            }
        }
        
        return path
    }
    
    
    func occupiedCells(for player: Int) -> [Cell] {
        return rocksPositions[player]!.compactMap { map.cell(for: $0, player: player) }
    }
    
    
    func occupiedCells(for players: [Int]) -> [Cell] {
        return players.flatMap { occupiedCells(for: $0) }
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
