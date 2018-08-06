//
//  MapConfig.swift
//  ur
//
//  Created by MSQUARDIAN on 7/18/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation

// MARK: Map Config

struct MapConfig {
    let height: Int
    let width: Int
    let highgroundsCells: Set<Cell>
    let path: [PlayerIdentifier: [Cell]]
}

// MARK: Cell

struct Cell: Hashable, Equatable, Codable {
    let x: Int
    let y: Int
}

extension Cell: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(x):\(y)"
    }
}

// MARK: Player Identifier

struct PlayerIdentifier: Hashable, Equatable, Codable {
    var id: Int
}

extension PlayerIdentifier: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int

    init(integerLiteral value: IntegerLiteralType) {
        self.init(id: value)
    }
}

extension PlayerIdentifier: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Player_\(id)"
    }
}
