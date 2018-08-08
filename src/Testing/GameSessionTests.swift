//
//  GameSessionTests.swift
//  ur-Tests
//
//  Created by MSQUARDIAN on 8/6/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

@testable import ur
import XCTest

class GameSessionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
    }

    let blueprints: [(rules: GameRules, players: [PlayerIdentifier], rockPositions: [PlayerIdentifier: [PathPosition]])] = [
        (GameRulesModels.smallMapOnePlayer, [0], [0: [.start]]),
        (GameRulesModels.twoPlayersSmall, [0, 1], [0: [.start, .start], 1: [.start, .start]]),
        (GameRulesModels.huge, [0], [0: [.start]])
    ]

    func testGameSessionInit() {

        for (gameRules, players, rockPositions) in blueprints {
            let testSession = GameSession(rules: gameRules)

            XCTAssertEqual(testSession.currentPlayer, 0)
            XCTAssertEqual(testSession.players, players)
            XCTAssertEqual(testSession.moveState, .idling)
            XCTAssertEqual(testSession.gameRules, gameRules)
            XCTAssertEqual(testSession.dices, gameRules.diceSet)
            XCTAssertEqual(testSession.rocksPositions, rockPositions)
        }
    }

    func testRandomFirstMove() {
        let (gameRules, _, _) = blueprints[1]

        var casesChecked = Set<Int>()
        while casesChecked.count < 5 {
            let testSession = GameSession(rules: gameRules)
            testSession.throwDices()
            let stepSize = testSession.stepSize
            switch stepSize {
            case nil:
                XCTAssertEqual(testSession.currentPlayer, 1)
                XCTAssertEqual(testSession.moveState, .idling)
                casesChecked.insert(0)
            case 1:
                XCTAssertEqual(testSession.currentPlayer, 0)
                XCTAssertEqual(testSession.availableMoves, [PathSearchResult(["0;0"], .start, 0)])
                casesChecked.insert(1)
            case 2:
                XCTAssertEqual(testSession.currentPlayer, 0)
                XCTAssertEqual(testSession.availableMoves, [PathSearchResult(["0;0", "0;1"], .start, 1)])
                casesChecked.insert(2)
            case 3:
                XCTAssertEqual(testSession.currentPlayer, 0)
                XCTAssertEqual(testSession.availableMoves, [PathSearchResult(["0;0", "0;1", "0;2"], .start, 2)])
                casesChecked.insert(3)
            case 4:
                XCTAssertEqual(testSession.currentPlayer, 0)
                XCTAssertEqual(testSession.availableMoves, [PathSearchResult(["0;0", "0;1", "0;2", "0:3"], .start, 3)])
                casesChecked.insert(4)
            default:
                XCTFail("\(String(describing: stepSize)) cannot be out of range")
            }
        }
    }
}
