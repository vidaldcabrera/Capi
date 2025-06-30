//
//  PauseScene.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 23/06/25.
//

import Foundation
import SpriteKit

class PauseScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .black
        self.isUserInteractionEnabled = true

        // Fundo escuro com transparência
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.2), size: size)
        overlay.position = CGPoint(x: frame.midX, y: frame.midY)
        overlay.zPosition = 12
        addChild(overlay)

        // Caixa de pausa
        let box = SKSpriteNode(imageNamed: "paused_box")
        box.position = CGPoint(x: frame.midX, y: frame.midY)
        box.setScale(1.5)
        box.zPosition = 14
        addChild(box)

        // Texto "Pausado"
        let title = SKSpriteNode(imageNamed: "paused_txt")
        title.position = CGPoint(x: frame.midX, y: frame.midY + 160)
        title.zPosition = 15
        addChild(title)

        // Botão "Continuar"
        let resumeButton = SKSpriteNode(imageNamed: "resume_button")
        resumeButton.name = "resumeButton"
        resumeButton.position = CGPoint(x: frame.midX, y: frame.midY + 90)
        resumeButton.setScale(0.8)
        resumeButton.zPosition = 15
        addChild(resumeButton)

        // Botão "Reiniciar"
        let restartButton = SKSpriteNode(imageNamed: "restart_button")
        restartButton.name = "restartButton"
        restartButton.position = CGPoint(x: frame.midX, y: frame.midY + 10)
        restartButton.setScale(0.8)
        restartButton.zPosition = 15
        addChild(restartButton)

        // Botão "Configurações"
        let settingsButton = SKSpriteNode(imageNamed: "settings_button")
        settingsButton.name = "settingsButton"
        settingsButton.position = CGPoint(x: frame.midX, y: frame.midY - 70)
        settingsButton.setScale(0.8)
        settingsButton.zPosition = 15
        addChild(settingsButton)

        // Botão "Sair"
        let quitButton = SKSpriteNode(imageNamed: "quit_button")
        quitButton.name = "quitButton"
        quitButton.position = CGPoint(x: frame.midX, y: frame.midY - 150)
        quitButton.setScale(0.8)
        quitButton.zPosition = 15
        addChild(quitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            switch node.name {
            case "resumeButton":
                VoiceOverManager.shared.speak("Jogo retomado")
                let resumeScene = GamePlayScene(size: self.size)
                resumeScene.scaleMode = .aspectFill
                view?.presentScene(resumeScene, transition: .fade(withDuration: 0.5))

            case "restartButton":
                VoiceOverManager.shared.speak("Jogo reiniciado")

                let restartScene = GameScene(size: self.size)
                restartScene.scaleMode = .aspectFill
                view?.presentScene(restartScene, transition: .fade(withDuration: 0.6))

            case "settingsButton":
                VoiceOverManager.shared.speak("Configurações")

                let settingsPauseScene = SettingsPauseScene(size: self.size)
                settingsPauseScene.scaleMode = .aspectFill
                view?.presentScene(settingsPauseScene, transition: .fade(withDuration: 0.6))

            case "quitButton":
                VoiceOverManager.shared.speak("Saindo do jogo")

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    exit(0)
                }

            default:
                break
            }
        }
    }
}
