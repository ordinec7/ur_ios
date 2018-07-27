//
//  Map.swift
//  ur
//
//  Created by MSQUARDIAN on 7/18/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation

class Map {
    let config: MapConfig
    var validCells: Set<Cell> {
        return Set(config.path.values.flatMap({ $0 }))
    }
    
    /// Calculates path from given cell.
    /// - parameter cell: Initial cell, from which path should be calculated. If nil, calculates path from outside the field
    /// - parameter length: Step size. Should be greated than 0, or else invalid path is returned
    /// - parameter player: Player id for which path sould be calculated
    public func findPath(from position: PathPosition, withStep stepSize: Int, player: Int) -> PathSearchResult? {
        guard stepSize > 0,
            let playerPath = config.path[player],
            let startIndex = position.value,
            startIndex < playerPath.endIndex && startIndex >= playerPath.startIndex else {
            return nil
        }
        
        let stepSize = stepSize + (position == .start ? -1 : 0)
        let finalIndex = startIndex + stepSize
        let path = playerPath.suffix(from: startIndex).prefix(stepSize + 1)
        
        switch finalIndex {
        case ..<playerPath.endIndex:
            return PathSearchResult(path, .onPath(finalIndex))
        case playerPath.endIndex:
            return PathSearchResult(path, .exit)
        default:
            return nil
        }
    }
    
    public func isHighground(cell: Cell) -> Bool {
        return config.highgroundsCells.contains(cell)
    }
    
    init(config: MapConfig) {
        self.config = config
    }
}


struct PathSearchResult: Equatable {
    let path: [Cell]
    let finalPosition: PathPosition
    
    init(_ path: [Cell], _ finalPosition: PathPosition) {
        self.path = path
        self.finalPosition = finalPosition
    }
    init(_ path: ArraySlice<Cell>, _ finalPosition: PathPosition) {
        self.path = Array(path)
        self.finalPosition = finalPosition
    }
}


enum PathPosition: Equatable {
    case start
    case exit
    case onPath(Int)
}


extension PathPosition {
    var value: Int? {
        switch self {
        case .start:
            return 0
        case .onPath(let index):
            return index
        case .exit:
            return nil
        }
    }
}


extension PathPosition: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int
    public init(integerLiteral value: IntegerLiteralType) {
        self = .onPath(value)
    }
}


extension PathPosition: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .start:
            return "START"
        case .exit:
            return "EXIT"
        case .onPath(let i):
            return "\(i)"
        }
    }
}
