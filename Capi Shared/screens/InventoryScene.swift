//
//  InventoryScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 27/06/25.
//

import Foundation
import SpriteKit

class InventoryScene: SKScene {
    
    override func didMove(to view: SKView) {
        //        backgroundColor = .black
        self.isUserInteractionEnabled = true

        // Fundo escuro com transparência
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.2), size: size)
        overlay.position = CGPoint(x: frame.midX, y: frame.midY)
        overlay.zPosition = 12
        addChild(overlay)

        // Caixa
        let box = SKSpriteNode(imageNamed: "control_box")
        box.position = CGPoint(x: frame.midX, y: frame.midY)
        box.setScale(0.8)
        box.zPosition = 14
        addChild(box)
        
        let backButton = SKSpriteNode(imageNamed: "back_button")
        backButton.name = "backButton"
        backButton.position = CGPoint(x: frame.width/2 - 440, y: frame.height/2 + 130)
        backButton.setScale(0.8)
        backButton.zPosition = 15
        addChild(backButton)
        

        // Título
        let localizedTitle = LocalizationManager.shared.localizedString(forKey: "active")
        let titleLabel = FontFactory.makeTitle(localizedTitle, at: CGPoint(x: frame.width/2 - 300, y: frame.height/2 + 130))
        titleLabel.zPosition = 15
        addChild(titleLabel)
        
        // Título
        let localizedTitle2 = LocalizationManager.shared.localizedString(forKey: "available")
        let titleLabel2 = FontFactory.makeTitle(localizedTitle2, at: CGPoint(x: frame.width/2 + 160, y: frame.height/2 + 130))
        titleLabel2.zPosition = 15
        addChild(titleLabel2)
        
        
        let separator = SKSpriteNode(imageNamed: "separator")
        separator.name = "separator"
        separator.position = CGPoint(x: frame.width/2 - 170, y: frame.height/2 - 40)
        separator.setScale(0.8)
        separator.zPosition = 15
        addChild(separator)
        
        let abilityLockedButton = SKSpriteNode(imageNamed: "ability_locked_button")
        abilityLockedButton.name = "backButton"
        abilityLockedButton.position = CGPoint(x: frame.width/2 - 300, y: frame.height/2 + 20)
        abilityLockedButton.setScale(0.8)
        abilityLockedButton.zPosition = 15
        addChild(abilityLockedButton)
        
        let abilityLockedButton1 = SKSpriteNode(imageNamed: "ability_locked_button")
        abilityLockedButton1.name = "backButton1"
        abilityLockedButton1.position = CGPoint(x: frame.width/2 - 300, y: frame.height/2 - 100)
        abilityLockedButton1.setScale(0.8)
        abilityLockedButton1.zPosition = 15
        addChild(abilityLockedButton1)
        
        let startX = frame.width / 2 - 300
        let verticalSpacing: CGFloat = -130
        let scale: CGFloat = 0.8

        for i in 2...5 {
            let button = SKSpriteNode(imageNamed: "ability_locked_button")
            button.name = "lockedButton_\(i)"
            button.position = CGPoint(x: startX - verticalSpacing * CGFloat(i), y: frame.height/2 + 20)
            button.setScale(scale)
            button.zPosition = 15
            addChild(button)
        }
        
        for i in 2...5 {
            let button = SKSpriteNode(imageNamed: "ability_locked_button")
            button.name = "lockedButton_\(i)"
            button.position = CGPoint(x: startX - verticalSpacing * CGFloat(i), y: frame.height/2 - 100)
            button.setScale(scale)
            button.zPosition = 15
            addChild(button)
        }


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            switch node.name {
            case "backButton":
//                print("ahhh")
                let backScene = GamePlayScene(size: self.size)
                backScene.scaleMode = .aspectFill
                view?.presentScene(backScene, transition: .fade(withDuration: 0.5))

//            case "restartButton":
//                let restartScene = GameScene(size: self.size)
//                restartScene.scaleMode = .aspectFill
//                view?.presentScene(restartScene, transition: .fade(withDuration: 0.6))
//
//            case "settingsButton":
//                let settingsPauseScene = SettingsPauseScene(size: self.size)
//                settingsPauseScene.scaleMode = .aspectFill
//                view?.presentScene(settingsPauseScene, transition: .fade(withDuration: 0.6))
//
//            case "quitButton":
//                exit(0)

            default:
                break
            }
        }
    }
}
