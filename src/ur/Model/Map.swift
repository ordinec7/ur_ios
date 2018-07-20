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
    var validCells: [Cell] {
        var paths: [Cell] = []
        for player in config.path.keys {
            paths += config.path[player]!
        }
        return Array(Set(paths))
    }
    public func movePath(from cell: Cell, with length: Int, player: Int) -> PathSearchResult {
        if let playerPath = config.path[player], let startIndex = playerPath.index(of: cell) {
            let endIndex = startIndex + length
            if config.path[endIndex] != nil {
                let pathCells = Array(playerPath[startIndex..<endIndex])
                return (endIndex == playerPath.endIndex) ? .exit(pathCells) : .valid(pathCells)
            } else {
                return (.invalid)
            }
        }
        //???
        return (.invalid)
    }
    public func isHighground(cell: Cell) -> Bool {
        for someHighgroundCell in config.highgroundsCells {
            if someHighgroundCell == cell {return true}
        }
        return false
    }
    
    init(config: MapConfig) {
        self.config = config
    }
}

enum PathSearchResult {
    case valid([Cell])
    case exit([Cell])
    case invalid
}
