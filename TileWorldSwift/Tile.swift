//
//  Tile.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import Foundation

class Tile : GridObject {
    var score : UInt8
    
    init(_ num : uint8,_ location : Location, _ score: uint8) {
        self.score = score
        super.init(num, location)
    }
}
