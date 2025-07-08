//
//  GameViewController.swift
//  Capi macOS
//
//  Created by Aluno 48 on 26/05/25.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GKScene(fileNamed: "GameScene") {
            
            if let sceneNode = scene.rootNode as! GameScene? {
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    #if DEBUG
                    view.showsPhysics = true
                    view.showsFPS = true
                    #endif
                }
            }
        }
        
    }
    
}
