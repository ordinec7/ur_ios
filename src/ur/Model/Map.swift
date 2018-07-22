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
//        var paths: [Cell] = []
//        for player in config.path.keys {
//            paths += config.path[player]!
//        }
        return Set(config.path.values.flatMap({ $0 }))
//        return Array(Set(paths))
    }
    public func movePath(from cell: Cell, with length: Int, player: Int) -> PathSearchResult {
        guard length > 0,
            let playerPath = config.path[player],
            let startIndex = playerPath.index(of: cell) else {
            return .invalid
        }
        
        let endIndex = startIndex + length
        if endIndex <= playerPath.endIndex {
            let pathCells = Array(playerPath[startIndex..<endIndex])
            return (endIndex == playerPath.endIndex) ? .exit(pathCells) : .valid(pathCells)
        } else {
            return (.invalid)
        }
    }
    public func isHighground(cell: Cell) -> Bool {
        return config.highgroundsCells.contains(cell)
//        for someHighgroundCell in config.highgroundsCells {
//            if someHighgroundCell == cell {return true}
//        }
//        return false
    }
    
    init(config: MapConfig) {
        self.config = config
    }
}

enum PathSearchResult: Equatable {
    case valid([Cell])
    case exit([Cell])
    case invalid
}
