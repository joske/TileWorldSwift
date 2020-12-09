//
//  Location.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import Foundation

enum Direction {
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

class Location : Hashable {
    var col : uint8
    var row : uint8
    
    init(_ col : uint8,_ row : uint8) {
        self.col = col
        self.row = row
    }
    
    func distance(_ other:Location) -> Int {
        return abs(Int(col - other.col)) + abs(Int(row - other.row))
    }

    func nextLocation(_ dir : Direction) -> Location {
        switch dir {
        case Direction.UP:
            return Location(col, row - 1)
        case Direction.DOWN:
            return Location(col, row + 1)
        case Direction.LEFT:
            return Location(col - 1, row)
        default:
            return Location(col + 1, row)
        }
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.col == rhs.col && lhs.row == rhs.row
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(col)
        hasher.combine(row)
    }
}
