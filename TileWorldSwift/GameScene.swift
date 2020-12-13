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
        let size : CGSize = CGSize(width: Int(grid.COLS) * MAG + 250, height	: Int(grid.ROWS) * MAG)
        super.init(size: size)

    }
    
    func getColor(_ i:uint8) -> NSColor {
        switch i {
        case 0:
            return SKColor.blue
        case 1:
            return SKColor.yellow
        case 2:
            return SKColor.green
        case 3:
            return SKColor.red
        case 4:
            return SKColor.purple
        default:
            return SKColor.cyan
        }
    }

    func drawAgent(_ agent: Agent,_ x : Int,_ y: Int) {
        let rect = SKShapeNode.init(rectOf: CGSize.init(width: MAG, height: MAG))
        rect.position = CGPoint(x:x, y:y)
        let color = getColor(agent.num)
        rect.strokeColor = color
        addChild(rect)
        if (agent.hasTile) {
            let circ = SKShapeNode(circleOfRadius: CGFloat(MAG/2))
            circ.position = CGPoint(x:x, y:y)
            circ.strokeColor = color
            addChild(circ)
            let text = SKLabelNode()
            text.text = "\(agent.tile!.score)"
            text.fontSize = 8
            text.fontColor = color
            text.position = CGPoint(x:x, y:y-3)
            addChild(text)
        }
    }
    
    func drawTile(_ tile: Tile,_ x : Int,_ y: Int) {
        let circ = SKShapeNode(circleOfRadius: CGFloat(MAG/2))
        circ.position = CGPoint(x:x, y:y)
        circ.strokeColor = SKColor.black
        addChild(circ)
        let text = SKLabelNode()
        text.text = "\(tile.score)"
        text.fontSize = 8
        text.fontColor = SKColor.black
        text.position = CGPoint(x:x, y:y-3)
        addChild(text)
    }

    func drawHole(_ hole: Hole,_ x : Int,_ y: Int) {
        let circ = SKShapeNode(circleOfRadius: CGFloat(MAG/2))
        circ.position = CGPoint(x:x, y:y)
        circ.fillColor = SKColor.black
        circ.strokeColor = SKColor.black
        addChild(circ)
    }

    func drawObstacle(_ o: Obstacle,_ x : Int,_ y: Int) {
        let rect = SKShapeNode.init(rectOf: CGSize.init(width: MAG, height: MAG))
        rect.position = CGPoint(x:x, y:y)
        rect.fillColor = SKColor.black
        rect.strokeColor = SKColor.black
        addChild(rect)
    }

    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.backgroundColor = SKColor.white
        removeAllChildren()
        for r in 0..<grid.ROWS {
            for c in 0..<grid.COLS {
                let x = Int(c) * MAG + MAG / 2
                let y = Int(r) * MAG + MAG / 2
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
        let x = grid.COLS * MAG + 100
        let y = grid.ROWS * MAG - 20
        for a in grid.agents {
            let text = SKLabelNode()
            text.text = "Agent \(a.num): \(a.score)"
            text.fontColor = getColor(a.num)
            text.fontSize = 8
            text.position = CGPoint(x:x, y: y - Int(a.num) * MAG)
            addChild(text)
        }
    }
}
