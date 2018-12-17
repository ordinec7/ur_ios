//
//  GameSession.swift
//  ur
//
//  Created by Anton on 7/27/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation

protocol GameSessionDelegate: class {
    func player(_ player: PlayerIdentifier, doesntHaveAnyMoveIn session: GameSession)
    func player(_ player: PlayerIdentifier, isReadyToThrowDicesIn session: GameSession)
    func player(_ player: PlayerIdentifier, isReadyToMakeAMoveIn session: GameSession)
    func player(_ player: PlayerIdentifier, makesAdditionalTurnIn session: GameSession)
}

class GameSession {

    /// Show if player did roll the dices and ret
    enum MoveState: Equatable {
        case idling
        case makingMove(dices: [Int])  // swiftlint:disable:this identifier_name
    }

    struct GameState {
        var moveState: MoveState
        var rocksPositions: [PlayerIdentifier: [PathPosition]]
        var currentPlayerIndex: Int
    }

    weak var delegate: GameSessionDelegate?

    let gameRules: GameRules
    let dices: DiceSet
    let map: Map
    let players: [PlayerIdentifier]

    var gameState: GameState

    var moveState: MoveState {
        get { return gameState.moveState }
        set { gameState.moveState = newValue }
    }

    /// All rocks positions per player
    var rocksPositions: [PlayerIdentifier: [PathPosition]] {
        get { return gameState.rocksPositions }
        set { gameState.rocksPositions = newValue }
    }
    var currentPlayerIndex: Int {
        get { return gameState.currentPlayerIndex }
        set { gameState.currentPlayerIndex = newValue }
    }

    var currentPlayer: PlayerIdentifier {
        return players[currentPlayerIndex]
    }
    var nextPlayerIndex: Int {
        return (currentPlayerIndex + 1) % players.count
    }
    var nextPlayer: PlayerIdentifier {
        return players[nextPlayerIndex]
    }

    // MARK: - Move functions

    /// Throw new dices
    @discardableResult
    func throwDices() -> [Int] {
        guard case .idling = moveState else {
            preconditionFailure("Can't throw new dices before making or skipping a move with previous throw")
        }
        let dicesThrow = dices.next()
        moveState = .makingMove(dices: dicesThrow)
        if availableMoves.isEmpty == false {
            delegate?.player(currentPlayer, isReadyToMakeAMoveIn: self)
        } else {
            delegate?.player(currentPlayer, doesntHaveAnyMoveIn: self)
            passTurn()
        }
        return dicesThrow
    }

    /// Move rock from given position for
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

    /// End current player's turn
    private func passTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        moveState = .idling
        delegate?.player(currentPlayer, isReadyToThrowDicesIn: self)
    }

    private func makeAdditionalTurn() {
        moveState = .idling
        delegate?.player(currentPlayer, makesAdditionalTurnIn: self)
        delegate?.player(currentPlayer, isReadyToThrowDicesIn: self)
    }

    // MARK: - Data properties

    /// Sum of thrown dices
    var stepSize: Int? {
        return diceThrow?.reduce(0, +)
    }

    /// Return dices values if they were thrown
    var diceThrow: [Int]? {
        guard case let .makingMove(dices: diceThrow) = moveState else {
            return nil
        }
        return diceThrow
    }

    /// Return array of available moves
    var availableMoves: [PathSearchResult] {
        return Set(rocksPositions[currentPlayer]!).compactMap { self.findMove(from: $0) }
    }

    /// Return path from given position
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

    /// Return array of occupied cells of player
    func occupiedCells(for player: PlayerIdentifier) -> [Cell] {
        return rocksPositions[player]!.compactMap { map.cell(for: $0, player: player) }
    }

    func occupiedCells(for players: [PlayerIdentifier]) -> [Cell] {
        return players.flatMap { occupiedCells(for: $0) }
    }

    convenience init(rules: GameRules) {
        self.init(rules: rules, state: .init(moveState: .idling, rocksPositions: [:], currentPlayerIndex: 0))

        for player in players {
            rocksPositions[player] = Array(repeating: .start, count: rules.rocksCount)
        }
    }

    init(rules: GameRules, state: GameState) {
        self.map = Map(config: rules.mapConfig)
        self.dices = rules.diceSet
        self.players = map.players.sorted { $0.id < $1.id }

        self.gameRules = rules
        self.gameState = state
    }
}
