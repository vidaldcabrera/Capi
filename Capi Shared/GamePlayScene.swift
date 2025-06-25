//
//  GamePlayScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 18/06/25.
//

import Foundation
import SpriteKit
import GameplayKit

class GamePlayScene: SKScene {
    override func didMove(to view: SKView) {
//        backgroundColor = .black
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

//        let bg = SKSpriteNode(color: .darkGray, size: self.size)
//        bg.position = .zero
//        bg.zPosition = -10
//        addChild(bg)

        let player = SKSpriteNode(imageNamed: "player")
        player.position = GameState.shared.playerPosition
        player.zPosition = 5
        addChild(player)

        let hud = HUDOverlay()
//        hud.updateScore(to: GameState.shared.score)
//        hud.updateLives(to: GameState.shared.lives)
        hud.position = CGPoint(x: 0, y: 0)
        hud.setupHUD(for: size)
        addChild(hud)
    }
}
