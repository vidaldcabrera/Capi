//  GameScene.swift
//  Capi Shared
//
//  Created by Aluno 48 on 26/05/25.

import SpriteKit
import GameplayKit

func proportionalScale(view: SKView, baseWidth: CGFloat = 390.0, multiplier: CGFloat) -> CGFloat {
    return (view.frame.width / baseWidth) * multiplier
}

class GameScene: SKScene {
    var entityManager = SKEntityManager()

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .black

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

        let title = SKSpriteNode(imageNamed: "title")
        title.position = CGPoint(x: 0, y: view.frame.height * 0.45)
        title.setScale(proportionalScale(view: view, multiplier: 0.7))
        title.zPosition = 0
        addChild(title)

        let buttons: [(String, CGFloat, () -> Void)] = [
            ("start_button", 0.1, {
                let scene = LevelScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("options_button", -0.14, {
                let scene = SettingsScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("difficulty_button", -0.37, {
                let scene = DifficultyScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("credits_button", -0.6, {
                let scene = CreditsScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            })
        ]

        for (name, relativeY, action) in buttons {
            let button = ButtonEntity(
                imageNamed: name,
                position: CGPoint(x: 0, y: view.frame.height * relativeY),
                name: name,
                action: action
            )
            entityManager.add(entity: button)
            if let node = button.component(ofType: GKSKNodeComponent.self)?.node {
                node.setScale(proportionalScale(view: view, multiplier: 0.4))
                addChild(node)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for entity in entityManager.entities {
            if let button = entity.component(ofType: ButtonComponent.self) {
                button.handleTouch(location: location)
            }
        }
    }
}
