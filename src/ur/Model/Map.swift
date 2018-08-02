//
//  Map.swift
//  ur
//
//  Created by MSQUARDIAN on 7/18/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation

struct Map {
    internal let config: MapConfig
    
    let height: Int
    let width: Int
    let origin: Cell
    let validCells: Set<Cell>
    var players: [PlayerIdentifier]
    
    /// Calculate path from given cell.
    /// - parameter cell: Initial cell, from which path should be calculated. If nil, calculates path from outside the field
    /// - parameter length: Step size. Should be greated than 0, or else invalid path is returned
    /// - parameter player: Player id for which path sould be calculated
    public func findPath(from startPosition: PathPosition, withStep stepSize: Int, player: PlayerIdentifier) -> PathSearchResult? {
        guard stepSize > 0,
            let playerPath = config.path[player],
            let startIndex = startPosition.value,
            startIndex < playerPath.endIndex && startIndex >= playerPath.startIndex else {
            return nil
        }
        
        let stepSize = stepSize + (startPosition == .start ? -1 : 0)
        let finalIndex = startIndex + stepSize
        
        guard finalIndex <= playerPath.endIndex else {
            return nil
        }
        
        let path = playerPath.suffix(from: startIndex).prefix(stepSize + 1)
        let finalPosition = finalIndex < playerPath.endIndex ? PathPosition.onPath(finalIndex) : .exit
        
        return PathSearchResult(path, startPosition, finalPosition)
    }
    

    /// Return map cell from players paths index
    public func cell(for position: PathPosition, player: PlayerIdentifier) -> Cell? {
        guard case let .onPath(index) = position,
            let playerPath = config.path[player],
            index >= playerPath.startIndex && index < playerPath.endIndex  else {
            return nil
        }
        return playerPath[index]
    }
    
    /// Tell if given cell is highgrounded
    public func isHighground(cell: Cell) -> Bool {
        return config.highgroundsCells.contains(cell)
    }
    
    init(config: MapConfig) {
        self.config = config
        self.validCells = Set(config.path.values.flatMap({ $0 }))
        self.players = Array(config.path.keys)
        
        var minmax = (minX: 0, minY: 0, maxX: 0, maxY: 0)
        validCells.forEach {
            minmax = (min(minmax.minX, $0.x),
                      min(minmax.minY, $0.y),
                      max(minmax.maxX, $0.x),
                      max(minmax.maxY, $0.y))
        }
        self.height = minmax.maxY - minmax.minY
        self.width = minmax.maxX - minmax.minX
        self.origin = Cell(x: -minmax.minX, y: -minmax.minY)
    }
}


/// Complete path data
struct PathSearchResult: Equatable {
    let path: [Cell]
    let startPosition: PathPosition
    let finalPosition: PathPosition
    let startCell: Cell?
    let finalCell: Cell?
    
    init(_ path: [Cell], _ startPosition: PathPosition, _ finalPosition: PathPosition) {
        self.path = path
        self.startPosition = startPosition
        self.finalPosition = finalPosition
        self.startCell = startPosition.isOnPath ? path.first! : nil
        self.finalCell = finalPosition.isOnPath ? path.last! : nil
    }
    
    fileprivate init(_ path: ArraySlice<Cell>, _ startPosition: PathPosition, _ finalPosition: PathPosition) {
        self.init(Array(path), startPosition, finalPosition)
    }
}


/// Position of the path
enum PathPosition: Equatable {
    case start
    case exit
    case onPath(Int)
}


extension PathPosition {
    
    /// Position's index, strart = 0 too
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
    
    var isOnPath: Bool {
        switch self {
        case .onPath:
            return true
        default:
            return false
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
