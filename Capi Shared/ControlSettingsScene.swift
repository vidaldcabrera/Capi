//  ControlSettingsScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 23/06/25.

import Foundation
import SpriteKit

class ControlSettingsScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        self.isUserInteractionEnabled = true

        // Obter dimensões reais da tela
        let screenBounds = UIScreen.main.bounds
        let panelSize = CGSize(width: screenBounds.width , height: screenBounds.height )

        // Painel transparente com o tamanho exato da tela
        let panel = SKShapeNode(rectOf: panelSize, cornerRadius: 50)
        panel.fillColor = .blue
        
//        panel.strokeColor = .black
        panel.position = CGPoint(x: frame.midX, y: frame.midY)

        panel.zPosition = 15
        addChild(panel)

//        // Referência de tamanho útil do painel
//        let pw = panel.frame.width
//        let ph = panel.frame.height
//        let buttonScale = (min(pw, ph) / 800)

//        // Painel de Configurações
//        let box = SKSpriteNode(imageNamed: "control_box")
//        box.position = CGPoint(x: frame.midX, y: frame.midY)
////        box.setScale(0.9)
//        box.zPosition = 14
//        addChild(box)

        // Título
        let title = SKSpriteNode(imageNamed: "control_settings_txt")
        title.position = CGPoint(x: frame.midX, y: frame.midY + 190)
        title.zPosition = 15
        addChild(title)
        
                
        let backButton = SKSpriteNode(imageNamed: "back_button")
        backButton.name = "backButton"
        backButton.position = CGPoint(x: frame.width/2 - 570, y: frame.height/2 + 190)
        backButton.zPosition = 30
        addChild(backButton)
        
        let hudPreview = HUDOverlayPreview(panelSize: panel.frame.size )
        hudPreview.position = CGPoint.zero
        hudPreview.zPosition = 16
        panel.addChild(hudPreview)


//        // Botões dentro do painel com posições proporcionais
//        let leftButton = SKSpriteNode(imageNamed: "left_button")
//        leftButton.position = CGPoint(x: -pw/2 + 100, y: -ph/2 + 120)
//        leftButton.setScale(buttonScale)
//        leftButton.zPosition = 1
//        panel.addChild(leftButton)
//
//        let rightButton = SKSpriteNode(imageNamed: "right_button")
//        rightButton.position = CGPoint(x: -pw/2 + 220, y: -ph/2 + 120)
//        rightButton.setScale(buttonScale)
//        rightButton.zPosition = 1
//        panel.addChild(rightButton)
//
//        let jumpButton = SKSpriteNode(imageNamed: "up_button")
//        jumpButton.position = CGPoint(x: pw/2 - 120, y: -ph/2 + 200)
//        jumpButton.setScale(buttonScale)
//        jumpButton.zPosition = 1
//        panel.addChild(jumpButton)
//
//        let actionButton = SKSpriteNode(imageNamed: "action_button")
//        actionButton.position = CGPoint(x: pw/2 - 200, y: -ph/2 + 120)
//        actionButton.setScale(buttonScale)
//        actionButton.zPosition = 1
//        panel.addChild(actionButton)

        // Botão de voltar (fora do painel, no canto superior esquerdo)
//        let backButton = SKSpriteNode(imageNamed: "back_button")
//        backButton.name = "backButton"
//        backButton.position = CGPoint(x: frame.minX , y: frame.maxY )
//        backButton.setScale(0.8)
//        backButton.zPosition = 20
//        addChild(backButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes { // NAO TA VOLTANDO PRO SETTINGS
            if node.name == "backButton" {
                VoiceOverManager.shared.speak("Voltar")

                if let settingsPauseScene = SettingsPauseScene(fileNamed: "SettingsPauseScene") {
                    settingsPauseScene.scaleMode = .aspectFill
                    view?.presentScene(settingsPauseScene, transition: .fade(withDuration: 0.5))
                } else {
                    let settingsPauseScene = SettingsPauseScene(size: self.size)
                    settingsPauseScene.scaleMode = .aspectFill
                    view?.presentScene(settingsPauseScene, transition: .fade(withDuration: 0.5))
                }
            }
        }
    }
}
