//
//  Map.swift
//  ur
//
//  Created by MSQUARDIAN on 7/18/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import Foundation

struct Map {
    private let config: MapConfig
    
    let height: Int
    let width: Int
    let origin: Cell
    let validCells: Set<Cell>
    var players: [Int] { return Array(config.path.keys) }
    
    /// Calculates path from given cell.
    /// - parameter cell: Initial cell, from which path should be calculated. If nil, calculates path from outside the field
    /// - parameter length: Step size. Should be greated than 0, or else invalid path is returned
    /// - parameter player: Player id for which path sould be calculated
    public func findPath(from startPosition: PathPosition, withStep stepSize: Int, player: Int) -> PathSearchResult? {
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
        let finalCell = finalIndex < playerPath.endIndex ? path.last! : nil
        
        return PathSearchResult(path, startPosition, finalPosition, playerPath[startIndex], finalCell)
    }
    
    public func cell(for position: PathPosition, player: Int) -> Cell? {
        guard case let .onPath(index) = position,
            let playerPath = config.path[player],
            index >= playerPath.startIndex && index < playerPath.endIndex  else {
            return nil
        }
        return playerPath[index]
    }
    
    public func isHighground(cell: Cell) -> Bool {
        return config.highgroundsCells.contains(cell)
    }
    
    init(config: MapConfig) {
        self.config = config
        self.validCells = Set(config.path.values.flatMap({ $0 }))
        
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


struct PathSearchResult: Equatable {
    let path: [Cell]
    let startPosition: PathPosition
    let finalPosition: PathPosition
    let startCell: Cell?
    let finalCell: Cell?
    
    init(path: [Cell], startPosition: PathPosition, finalPosition: PathPosition, startCell: Cell?, finalCell: Cell?) {
        self.path = path
        self.startPosition = startPosition
        self.finalPosition = finalPosition
        self.startCell = startCell
        self.finalCell = finalCell
    }
    
    fileprivate init(_ path: ArraySlice<Cell>, _ startPosition: PathPosition, _ finalPosition: PathPosition, _ startCell: Cell?, _ finalCell: Cell?) {
        self.init(path: Array(path), startPosition: startPosition, finalPosition: finalPosition, startCell: startCell, finalCell: finalCell)
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
