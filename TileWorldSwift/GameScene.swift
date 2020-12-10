//
//  GameScene.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let MAG : Int = 10
    private let grid : Grid
    
    init(_ grid : Grid) {
        self.grid = grid
        let size : CGSize = CGSize(width: Int(grid.COLS) * MAG, height: Int(grid.ROWS) * MAG)
        super.init(size: size)

    }

    func drawAgent(_ agent: Agent,_ x : Int,_ y: Int) {
        let rect = SKShapeNode.init(rectOf: CGSize.init(width: MAG, height: MAG))
        rect.position = CGPoint(x:x, y:y)
        addChild(rect)
    }
    
    func drawTile(_ tile: Tile,_ x : Int,_ y: Int) {
        let circ = SKShapeNode(circleOfRadius: CGFloat(MAG/2))
        circ.position = CGPoint(x:x, y:y)
        addChild(circ)
    }

    func drawHole(_ hole: Hole,_ x : Int,_ y: Int) {
        let circ = SKShapeNode(circleOfRadius: CGFloat(MAG/2))
        circ.position = CGPoint(x:x, y:y)
        circ.fillColor = SKColor.black
        addChild(circ)
    }

    func drawObstacle(_ o: Obstacle,_ x : Int,_ y: Int) {
        let rect = SKShapeNode.init(rectOf: CGSize.init(width: MAG, height: MAG))
        rect.position = CGPoint(x:x, y:y)
        rect.fillColor = SKColor.black
        addChild(rect)
    }

    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    override func update(_ currentTime: TimeInterval) {
        grid.update()
        for r in 0..<grid.ROWS {
            for c in 0..<grid.COLS {
                let x = Int(c) * MAG
                let y = Int(r) * MAG
                let l = Location(c, r)
                let o = grid.getObject(l)
                if o is Agent {
                    drawAgent(o as! Agent, x, y)
                } else if o is Tile {
                    drawTile(o as! Tile, x, y)
                } else if o is Hole {
                    drawHole(o as! Hole, x, y)
                } else if o is Obstacle {
                    drawObstacle(o as! Obstacle, x, y)
                }
            }
        }
    }
}
