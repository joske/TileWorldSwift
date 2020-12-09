//
//  Grid.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import Foundation

class Grid {
    let COLS : uint8 = 40;
    let ROWS : uint8 = 40;
    let SLEEP : uint32 = 200;
    let numAgents : uint8
    let numTiles : uint8
    let numHoles : uint8
    let numObstacles : uint8
    
    var agents : Array<Agent> = []
    var tiles : Array<Tile> = []
    var holes : Array<Hole> = []
    var obstacles : Array<Obstacle> = []
    var objects : Dictionary<Location, GridObject> = [:]

    init(numAgents : uint8, numTiles : uint8, numHoles : uint8, numObstacles : uint8) {
        self.numAgents = numAgents
        self.numTiles = numTiles
        self.numHoles = numHoles
        self.numObstacles = numObstacles
      }

      func start() {
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
        while (true) {
          for a in agents {
            let orig = a.location
            a.update()
            let newLoc = a.location
            objects[orig] = nil
            objects[newLoc] = a
          }
          printGrid()
          sleep(SLEEP)
        }
      }

    func createAgent(_ i : uint8) {
        let l = randomFreeLocation()
        let agent = Agent(self, i, l)
        agents.append(agent)
        objects[l] = agent
      }

      func createTile(_ i : uint8) {
        let l = randomFreeLocation()
        let score =  uint8.random(in: 0...6)
        let tile = Tile(i, l, score)
        tiles.append(tile)
        objects[l] = tile
      }

      func createHole(_ i : uint8) {
        let l = randomFreeLocation();
        let hole = Hole(i, l)
        holes.append(hole);
        objects[l] = hole;
      }

      func createObstacle(_ i : uint8) {
        let l = randomFreeLocation();
        let obstacle : Obstacle = Obstacle(i, l)
        obstacles.append(obstacle)
        objects[l] = obstacle
      }

      func randomFreeLocation() -> Location {
        var col = uint8.random(in: 0..<COLS)
        var row = uint8.random(in: 0..<ROWS)
        var l : Location = Location(col, row)
        while (!isFree(l)) {
          col = uint8.random(in: 0..<COLS)
          row = uint8.random(in: 0..<ROWS)
          l = Location(col, row)
        }
        return l
      }

    func isFree(_ l : Location) -> Bool {
        return objects[l] == nil
      }

    func isValidMove(location : Location, dir : Direction)  -> Bool {
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
            let o = objects[l]
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

      func getClosestTile(location : Location) -> Tile? {
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

    func getClosestHole(location : Location) -> Hole? {
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
        objects[tile.location] = nil
        createTile(tile.num)
      }

    func removeHole(_ hole: Hole) {
        if let index = holes.firstIndex(of: hole) {
            holes.remove(at: index)
        }
        objects[hole.location] = nil
        createHole(hole.num)
      }
    
}
