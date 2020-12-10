//
//  ViewController.swift
//  TileWorldSwift
//
//  Created by Jos Dehaes on 07/12/2020.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let grid = Grid(5, 5, 5, 5)
        grid.start()
        if let scene = GameScene(grid) as GameScene? {
          // Configure the view.
          let skView = self.view as! SKView
          skView.showsFPS = true
          skView.showsNodeCount = true
          /* Sprite Kit applies additional optimizations to improve rendering performance */
          skView.ignoresSiblingOrder = false
          
          skView.presentScene(scene)
        }
    }
}

