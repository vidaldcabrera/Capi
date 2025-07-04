//
//  LevelScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 18/06/25.
//

import Foundation
import SpriteKit
import GameplayKit

class LevelScene: SKScene {
    var entityManager = SKEntityManager()

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .black

        // Fundo do mapa adaptado à tela
        let background = SKSpriteNode(imageNamed: "map")
        background.position = .zero
        background.size = view.frame.size
        background.setScale(proportionalScale(view: view, multiplier: 0.8))
        background.zPosition = -1
        addChild(background)
        
        // Título "LEVEL SELECTION"
        let cloud = SKSpriteNode(imageNamed: "cloud_level") // substitua pelo nome real da imagem
        cloud.position = CGPoint(x: -view.frame.width * 0.35, y: view.frame.height * 0.6)
        cloud.setScale(proportionalScale(view: view, multiplier: 0.5))
        cloud.zPosition = 3
        addChild(cloud)

        // Título "LEVEL SELECTION"
        let title = SKSpriteNode(imageNamed: "level_select_txt") // substitua pelo nome real da imagem
        title.position = CGPoint(x: -view.frame.width * 0.35, y: view.frame.height * 0.6)
        title.setScale(proportionalScale(view: view, multiplier: 0.5))
        title.zPosition = 4
        addChild(title)

        // Botão de voltar
        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "backButton"
        back.position = CGPoint(x: -view.frame.width * 0.7, y: view.frame.height * 0.6)
        back.setScale(proportionalScale(view: view, multiplier: 0.4))
        back.zPosition = 2
        addChild(back)

        // Botões de fases (posição proporcional baseada na imagem enviada)
        let levelPositions: [CGPoint] = [
            CGPoint(x:  0.5, y: -0.3), // laguinho - level1

//            CGPoint(x: -0.35, y: -0.15), // castelo sudoeste
//            CGPoint(x:  0.00, y:  0.25), // castelo norte
//            CGPoint(x:  0.05, y:  0.00), // deserto
//            CGPoint(x:  0.30, y:  0.35), // caverna nordeste
        ]

        for (index, relPos) in levelPositions.enumerated() {
            let levelButton = SKSpriteNode(imageNamed: "player") // ícone circular
            levelButton.name = "level_\(index + 1)"
            levelButton.position = CGPoint(
                x: view.frame.width * relPos.x,
                y: view.frame.height * relPos.y
            )
            levelButton.setScale(proportionalScale(view: view, multiplier: 0.3))
            levelButton.zPosition = 2
            addChild(levelButton)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            if node.name == "level_1" {
                let gameplayScene = GamePlayScene(size: self.size)
                gameplayScene.scaleMode = .aspectFill
                self.view?.presentScene(gameplayScene, transition: .fade(withDuration: 1))
            }  else if node.name == "backButton" {
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: .fade(withDuration: 1))
            }
        }
    }

}
