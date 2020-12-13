//
//  Path.swift
//  TileWorldSwiftTests
//
//  Created by Jos Dehaes on 13/12/2020.
//

import XCTest

@testable import TileWorldSwift

class PathTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
	
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let grid = Grid(0, 0, 0, 0)
        let tile = Tile(0, Location(0,1), 1)
        let agent = Agent(grid, 0, Location(0,0))
        let path = shortestPath(grid, agent.location, tile.location)
        XCTAssertNotNil(path)
        XCTAssertEqual(2, path.count)
    }

}
