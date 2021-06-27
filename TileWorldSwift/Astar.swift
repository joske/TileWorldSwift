//
//  astar.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 14/03/2021.
//

import Foundation
import SwiftPriorityQueue

class Node : Comparable, Hashable {
    let location : Location
    let path : Array<Location>
    let cost : Int
    init(location: Location, path: Array<Location>, cost:Int) {
        self.location = location
        self.path = path
        self.cost = cost
    }

    public static func < (lhs:Node, rhs:Node) -> Bool {
        return lhs.cost < rhs.cost
    }

    public static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.location == rhs.location
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
        hasher.combine(cost)
    }
}

public func astar(_ grid: Grid,_ from: Location,_ to: Location) -> Array<Location>{
    var openList = PriorityQueue<Node>(ascending: true)
    let fromNode = Node(location: from, path:[], cost:0)
    openList.push(fromNode)
    var closedList : Array<Node> = []
    while !openList.isEmpty {
        let currentNode = openList.pop()!
        if currentNode.location == to {
            return currentNode.path
        }
        closedList.append(currentNode)
        checkNeighbor(grid, &openList, closedList, currentNode, Direction.UP, from, to)
        checkNeighbor(grid, &openList, closedList, currentNode, Direction.DOWN, from, to)
        checkNeighbor(grid, &openList, closedList, currentNode, Direction.LEFT, from, to)
        checkNeighbor(grid, &openList, closedList, currentNode, Direction.RIGHT, from, to)
    }
    return []
}

func checkNeighbor(_ grid: Grid,_ openList : inout PriorityQueue<Node>, _ closedList : Array<Node>, _ current: Node, _ dir : Direction, _ from: Location,_ to: Location) {
    let nextLocation = current.location.nextLocation(dir)
    if (nextLocation == to || grid.isValidMove(current.location, dir)) {
        let h = nextLocation.distance(to)
        let g = current.location.distance(from) + 1
        var path = current.path
        path.append(nextLocation)
        let child = Node(location: nextLocation, path: path, cost: g + h)
        if (!closedList.contains(child)) {
            openList.push(child)
        }
    }
}
