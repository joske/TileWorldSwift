//
//  Agent.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import Foundation

enum State {
    case IDLE
    case MOVE_TO_TILE
    case MOVE_TO_HOLE
}

public class Agent : GridObject {
    var score : UInt8 = 0
    var tile : Tile? = nil
    var hole : Hole? = nil
    var hasTile : Bool = false
    var grid : Grid
    var state = State.IDLE
    var path : Array<Location> = []
    
    init(_ grid : Grid,_ num : uint8,_ location : Location) {
        self.grid = grid
        super.init(num, location)
    }
    
    func update() {
        if (state == State.IDLE) {
            idle()
        } else if (state == State.MOVE_TO_TILE) {
            moveToTile()
        } else {
            moveToHole()
        }
    }
    
    func idle() {
        tile = nil
        hole = nil
        hasTile = false
        tile = grid.getClosestTile(location)
        state = State.MOVE_TO_TILE
    }
    
    func moveToTile() {
        if (tile?.location == location) {
            // arrived
            pickTile();
            return
        }
        if grid.getObject(tile!.location) != tile {
            // tile gone
            state = State.IDLE
            return
        }
        let potentialTile = grid.getClosestTile(location)
        if potentialTile != tile {
            // this one is now closer
            tile = potentialTile
            path = astar(grid, location, tile!.location)
        }
        if path.isEmpty {
            path = astar(grid, location, tile!.location)
        }
        if !path.isEmpty {
            let nextLocation = path.remove(at: 0)
            if grid.isFree(nextLocation) || nextLocation == tile?.location {
                // could be an agent in our way (path is calculated upfront, but the other agents move too
                // wait one iteration and see if we can get unstuck
                nextMove(nextLocation)
            }
        }
    }
    
    func nextMove(_ nextLocation : Location) {
        location = nextLocation
    }
    
    func moveToHole() {
        if (hole!.location == location) {
            // arrived
            dumpTile()
            return
        }
        if grid.getObject(hole!.location) != hole {
            // hole gone
            hole = grid.getClosestHole(location)
            return
        }
        let potentialHole = grid.getClosestHole(location)
        if potentialHole != hole {
            // this one is now closer
            hole = potentialHole
            path = astar(grid, location, hole!.location)
        }
        if path.isEmpty {
            path = astar(grid, location, hole!.location)
        }
        if !path.isEmpty {
            let nextLocation = path.remove(at: 0)
            if grid.isFree(nextLocation) || nextLocation == hole?.location {
                // could be an agent in our way (path is calculated upfront, but the other agents move too
                // wait one iteration and see if we can get unstuck
                nextMove(nextLocation)
            }
        }
    }
    
    func pickTile() {
        hasTile = true
        hole = grid.getClosestHole(location)
        state = State.MOVE_TO_HOLE
        grid.removeTile(tile!)
    }
    
    func dumpTile() {
        grid.removeHole(hole!)
        score += tile!.score
        tile = nil
        hole = nil
        hasTile = false
        state = State.IDLE
    }
}

public func shortestPath(_ grid: Grid,_ from: Location,_ to: Location) -> Array<Direction> {
    var list : Array<Location> = []
    var queue : Dictionary<Int, Array<Location>> = [:]
    list.append(from)
    queue[0] = list
    while !queue.isEmpty {
        let key = queue.first?.key
        let path = queue.removeValue(forKey: key!)
        let last : Location = path!.last!
        if last == to {
            return makePath(path!)
        }
        generateNext(grid, to, path!, &queue, Direction.UP)
        generateNext(grid, to, path!, &queue, Direction.DOWN)
        generateNext(grid, to, path!, &queue, Direction.LEFT)
        generateNext(grid, to, path!, &queue, Direction.RIGHT)
    }
    return []
}

func generateNext(_ grid: Grid,_ to: Location,_ path: Array<Location>,_ queue: inout Dictionary<Int, Array<Location>>,_ dir:Direction) {
    let last = path.last
    let nextLocation = last?.nextLocation(dir)
    if (grid.isValidMove(last!, dir) || nextLocation == to) {
        var newPath : Array<Location> = []
        newPath += path
        if (!hasLoop(newPath, nextLocation!)) {
            newPath.append(nextLocation!)
            let cost = newPath.count + nextLocation!.distance(to)
            queue[cost] = newPath
        }
    }
}

func hasLoop(_ path: Array<Location>,_ location : Location) -> Bool {
    for l in path {
        if l == location {
            return true
        }
    }
    return false
}

func makePath(_ list: Array<Location>) -> Array<Direction> {
    var path : Array<Direction> = []
    var last = list[0]
    for l in list[1...] {
        let dir = last.getDirection(l)
        path.append(dir)
        last = l
    }
    return path
}
