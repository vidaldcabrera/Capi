//
//  SettingsScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 17/06/25.
//

import Foundation
import SpriteKit

//class BaseScene: SKScene {
//    func scaleToFill(sprite: SKSpriteNode) {
//        let xScale = size.width / sprite.size.width
//        let yScale = size.height / sprite.size.height
//        sprite.setScale(max(xScale, yScale))
//        sprite.position = .zero
//    }
//
//    func scaleToWidth(sprite: SKSpriteNode, percentage: CGFloat) {
//        let targetWidth = size.width * percentage
//        let scale = targetWidth / sprite.size.width
//        sprite.setScale(scale)
//    }
//}


class SettingsScene: SKScene {
    var entityManager = SKEntityManager()

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let background = SKSpriteNode(imageNamed: "map")
        background.position = .zero
        background.size = view.frame.size
        background.setScale(proportionalScale(view: view, multiplier: 0.8))
        background.zPosition = -2
        addChild(background)

        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.position = .zero
        cloud.size = view.frame.size
        cloud.setScale(proportionalScale(view: view, multiplier: 0.8))
        cloud.zPosition = -1
        addChild(cloud)

        let box = SKSpriteNode(imageNamed: "box")
        box.position = .zero
        box.setScale(proportionalScale(view: view, multiplier: 0.7))
        box.zPosition = 5
        addChild(box)

        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "backButton"
        back.position = CGPoint(x: 0, y: view.frame.height * -0.4)
        back.setScale(proportionalScale(view: view, multiplier: 0.35))
        back.zPosition = 6
        addChild(back)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "backButton" {
            VoiceOverManager.shared.speak("Voltar")
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
        }
    }
}


// MARK: - CreditsScene

class CreditsScene: SKScene {
    var entityManager = SKEntityManager()

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let background = SKSpriteNode(imageNamed: "map")
        background.position = .zero
        background.size = view.frame.size
        background.setScale(proportionalScale(view: view, multiplier: 0.8))
        background.zPosition = -2
        addChild(background)

        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.position = .zero
        cloud.size = view.frame.size
        cloud.setScale(proportionalScale(view: view, multiplier: 0.8))
        cloud.zPosition = -1
        addChild(cloud)

        let box = SKSpriteNode(imageNamed: "box")
        box.position = .zero
        box.setScale(proportionalScale(view: view, multiplier: 0.7))
        box.zPosition = 5
        addChild(box)

        let title = SKSpriteNode(imageNamed: "developers")
        title.position = CGPoint(x: 0, y: view.frame.height * 0.35)
        title.setScale(proportionalScale(view: view, multiplier: 0.6))
        title.zPosition = 6
        addChild(title)

        let names = SKSpriteNode(imageNamed: "names")
        names.position = CGPoint(x: 0, y: 0)
        names.setScale(proportionalScale(view: view, multiplier: 0.6))
        names.zPosition = 6
        addChild(names)

        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "backButton"
        back.position = CGPoint(x: 0, y: view.frame.height * -0.4)
        back.setScale(proportionalScale(view: view, multiplier: 0.35))
        back.zPosition = 6
        addChild(back)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "backButton" {
            VoiceOverManager.shared.speak("Voltar")
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
        }
    }
}


// MARK: - DifficultyScene

class DifficultyScene: SKScene {
    var entityManager = SKEntityManager()

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let background = SKSpriteNode(imageNamed: "map")
        background.position = .zero
        background.size = view.frame.size
        background.setScale(proportionalScale(view: view, multiplier: 0.8))
        background.zPosition = -2
        addChild(background)

        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.position = .zero
        cloud.size = view.frame.size
        cloud.setScale(proportionalScale(view: view, multiplier: 0.8))
        cloud.zPosition = -1
        addChild(cloud)

        let box = SKSpriteNode(imageNamed: "box")
        box.position = .zero
        box.setScale(proportionalScale(view: view, multiplier: 0.7))
        box.zPosition = 5
        addChild(box)

        let name = SKSpriteNode(imageNamed: "difficulty_txt")
        name.position = CGPoint(x: 0, y: view.frame.height * 0.35)
        name.setScale(proportionalScale(view: view, multiplier: 0.6))
        name.zPosition = 6
        addChild(name)

        let difficulties = ["easy_button", "normal_button", "extreme_button"]
        for (index, name) in difficulties.enumerated() {
            let button = SKSpriteNode(imageNamed: name)
            button.name = name
            button.position = CGPoint(x: 0, y: view.frame.height * (0.15 - CGFloat(index) * 0.19))
            button.setScale(proportionalScale(view: view, multiplier: 0.35))
            button.zPosition = 6
            addChild(button)
        }

        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "backButton"
        back.position = CGPoint(x: 0, y: view.frame.height * -0.4)
        back.setScale(proportionalScale(view: view, multiplier: 0.35))
        back.zPosition = 6
        addChild(back)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        if touchedNode.name == "backButton" {
            VoiceOverManager.shared.speak("Voltar")
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
        }
    }
}
