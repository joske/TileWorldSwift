//
//  Grid.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import Foundation

public class Grid {
    let COLS : Int = 50;
    let ROWS : Int = 50;
    let numAgents : uint8
    let numTiles : uint8
    let numHoles : uint8
    let numObstacles : uint8
    
    var agents : Array<Agent> = []
    var tiles : Array<Tile> = []
    var holes : Array<Hole> = []
    var obstacles : Array<Obstacle> = []
    var objects : [[GridObject?]]

    init(_ numAgents : uint8,_ numTiles : uint8,_ numHoles : uint8,_ numObstacles : uint8) {
        self.numAgents = numAgents
        self.numTiles = numTiles
        self.numHoles = numHoles
        self.numObstacles = numObstacles
        self.objects = Array(repeating: Array(repeating: nil, count: COLS), count: ROWS)
      }

      func createObjects() {
        for i in 0...numAgents - 1 {
          createAgent(i)
        }
        for i in 0...numTiles - 1 {
          createTile(i)
        }
        for i in 0...numHoles - 1 {
          createHole(i)
        }
        for i in 0...numObstacles - 1 {
          createObstacle(i)
        }
      }
    
    func getObject(_ loc: Location) -> GridObject? {
        return objects[loc.col][loc.row]
    }
    
    func setObject(_ loc: Location,_ o: GridObject?) {
        objects[loc.col][loc.row] = o
    }
    
    func update() {
        for a in agents {
            let orig = a.location
            setObject(orig, nil)
            a.update()
            let newLoc = a.location
            setObject(newLoc, a)
        }
        printGrid()
    }

    func createAgent(_ i : uint8) {
        let l = randomFreeLocation()
        let agent = Agent(self, i, l)
        agents.append(agent)
        setObject(l, agent)
      }

      func createTile(_ i : uint8) {
        let l = randomFreeLocation()
        let score =  uint8.random(in: 1...6)
        let tile = Tile(i, l, score)
        tiles.append(tile)
        setObject(l, tile)
      }

      func createHole(_ i : uint8) {
        let l = randomFreeLocation();
        let hole = Hole(i, l)
        holes.append(hole);
        setObject(l, hole)
      }

      func createObstacle(_ i : uint8) {
        let l = randomFreeLocation();
        let obstacle : Obstacle = Obstacle(i, l)
        obstacles.append(obstacle)
        setObject(l, obstacle)
      }

      func randomFreeLocation() -> Location {
        var col = Int.random(in: 0..<COLS)
        var row = Int.random(in: 0..<ROWS)
        var l : Location = Location(col, row)
        while (!isFree(l)) {
          col = Int.random(in: 0..<COLS)
          row = Int.random(in: 0..<ROWS)
          l = Location(col, row)
        }
        return l
      }

    func isFree(_ l : Location) -> Bool {
        return getObject(l) == nil
    }

    func isValidMove(_ location : Location,_ dir : Direction)  -> Bool {
        if (dir == Direction.UP) {
          return location.row > 0 && isFree(location.nextLocation(dir))
        } else if (dir == Direction.DOWN) {
          return location.row < ROWS - 1 && isFree(location.nextLocation(dir))
        } else if (dir == Direction.LEFT) {
          return location.col > 0 && isFree(location.nextLocation(dir))
        } else {
          return location.col < COLS - 1 && isFree(location.nextLocation(dir))
        }
      }

      func printGrid() {
        for r in 0...ROWS - 1 {
            for c in 0...COLS - 1 {
                let l = Location(c, r)
                let o = getObject(l)
                if (o != nil) {
                  if (o is Agent) {
                    if ((o as! Agent).hasTile) {
                      print("Å");
                    } else {
                      print("A");
                    }
                  } else if (o is Tile) {
                    print("T");
                  } else if (o is Hole) {
                    print("H");
                  } else {
                    print("#");
                  }
                } else {
                  print(".");
                }
          }
          print("");
        }
        for a in agents {
            print("Agent \(a.num): \(a.score)")
        }
      }

      func getClosestTile(_ location : Location) -> Tile? {
        var closest = 10000000
        var best : Tile? = nil
        for t in tiles {
          let distance = t.location.distance(location)
          if (distance < closest) {
            closest = distance
            best = t
          }
        }
        return best
      }

    func getClosestHole(_ location : Location) -> Hole? {
        var closest = 10000000;
        var best : Hole? = nil
        for h in holes {
          let distance = h.location.distance(location)
          if (distance < closest) {
            closest = distance
            best = h
          }
        }
        return best
      }

    func removeTile(_ tile: Tile) {
        if let index = tiles.firstIndex(of: tile) {
            tiles.remove(at: index)
        }
        setObject(tile.location, nil)
        createTile(tile.num)
      }

    func removeHole(_ hole: Hole) {
        if let index = holes.firstIndex(of: hole) {
            holes.remove(at: index)
        }
        setObject(hole.location, nil)
        createHole(hole.num)
      }
    
}
