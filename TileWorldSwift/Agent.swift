//
//  Agent.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import Foundation

class Agent : GridObject {
    var score : UInt8 = 0
    var tile : Tile? = nil
    var hole : Hole? = nil
    var hasTile : Bool = false
    var grid : Grid
    
    init(_ grid : Grid,_ num : uint8,_ location : Location) {
        self.grid = grid
        super.init(num, location)
    }
    
    func update() {
        
    }
}
