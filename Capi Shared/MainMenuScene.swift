//
//  MainMenuScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 17/06/25.
//


import Foundation
import SpriteKit

class MainMenuScene: SKScene {
//    var entityManager = SKEntityManager()
//
//    override func didMove(to view: SKView) {
//        self.size = view.bounds.size
//        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        // backgroundColor = .black
//
//        let background = SKSpriteNode(imageNamed: "map")
//        background.position = CGPoint(x: 0, y: 0)
//        background.zPosition = -2
//        addChild(background)
//
//        let cloud = SKSpriteNode(imageNamed: "cloud")
//        cloud.position = CGPoint(x: 0, y: 0)
//        cloud.zPosition = -1
//        addChild(cloud)
//
//        let box = SKSpriteNode(imageNamed: "box")
//        box.position = CGPoint(x: 0, y: 0)
//        box.zPosition = 5
//        addChild(box)
//
//        let startButton = SKSpriteNode(imageNamed: "start_button")
//        startButton.name = "start"
//        startButton.position = CGPoint(x: 0, y: 60)
//        startButton.zPosition = 6
//        addChild(startButton)
//
//        let settingsButton = SKSpriteNode(imageNamed: "settings_button")
//        settingsButton.name = "settings"
//        settingsButton.position = CGPoint(x: 0, y: -30)
//        settingsButton.zPosition = 6
//        addChild(settingsButton)
//
//        let creditsButton = SKSpriteNode(imageNamed: "credits_button")
//        creditsButton.name = "credits"
//        creditsButton.position = CGPoint(x: 0, y: -120)
//        creditsButton.zPosition = 6
//        addChild(creditsButton)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        let node = atPoint(location)
//
//        switch node.name {
//        case "start":
//            // trocar para GameScene ou DifficultyScene
//            let scene = DifficultyScene(size: self.size)
//            scene.scaleMode = .aspectFill
//            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
//
//        case "settings":
//            let scene = SettingsScene(size: self.size)
//            scene.scaleMode = .aspectFill
//            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
//
//        case "credits":
//            let scene = CreditsScene(size: self.size)
//            scene.scaleMode = .aspectFill
//            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
//
//        default:
//            break
//        }
//    }
}
