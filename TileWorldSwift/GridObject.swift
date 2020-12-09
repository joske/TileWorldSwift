//
//  GridObject.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import Foundation

class GridObject {
    var location : Location
    var num : uint8
    
    init(_ num : uint8,_ location : Location) {
        self.num = num
        self.location = location
    }
    
}

extension GridObject : Equatable {
    static func == (lhs:GridObject, rhs:GridObject) -> Bool {
        return lhs.location == rhs.location
    }
}
