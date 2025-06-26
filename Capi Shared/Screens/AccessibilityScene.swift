

import Foundation
import SpriteKit

class AccessibilityScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        self.isUserInteractionEnabled = true

        // Fundo escuro transparente
        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.7), size: size)
        overlay.position = CGPoint(x: frame.midX, y: frame.midY)
        overlay.zPosition = 12
        addChild(overlay)

        // Painel de Configurações
        let box = SKSpriteNode(imageNamed: "box")
        box.position = CGPoint(x: frame.midX, y: frame.midY)
        box.setScale(1.5)
        box.zPosition = 14
        addChild(box)
        
        // Título
        let title = SKSpriteNode(imageNamed: "accessibility_txt")
        title.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        title.zPosition = 15
        addChild(title)

        
        
        
        
        // Texto
        let audio = SKSpriteNode(imageNamed: "audio_txt")
        audio.position = CGPoint(x: frame.midX - 100, y: frame.midY + 60)
        audio.zPosition = 15
        addChild(audio)

        // Music Label

        let music = SKSpriteNode(imageNamed: "music_txt")
        music.position = CGPoint(x: frame.midX - 100, y: frame.midY)
        music.zPosition = 15
        addChild(music)

        // Controls Button
        let controlsButton = SKSpriteNode(imageNamed: "controls_button")
        controlsButton.name = "controls"
        controlsButton.position = CGPoint(x: frame.midX - 80, y: frame.midY - 80)
        controlsButton.setScale(0.8)
        controlsButton.zPosition = 15
        addChild(controlsButton)

        // Accessibility Button
        let accessibilityButton = SKSpriteNode(imageNamed: "accessibility_button")
        accessibilityButton.name = "accessibility"
        accessibilityButton.position = CGPoint(x: frame.midX + 100, y: frame.midY - 80)
        accessibilityButton.setScale(0.8)
        accessibilityButton.zPosition = 15
        addChild(accessibilityButton)

        
        
        
        
        
        
        
        // Back Button (voltar para PauseScene)
        let backButton = SKSpriteNode(imageNamed: "back_button")
        backButton.name = "back"
        backButton.position = CGPoint(x: frame.midX + 10, y: frame.midY - 150)
        backButton.setScale(0.8)
        backButton.zPosition = 15
        addChild(backButton)


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            if node.name == "backButton" {
                if let pauseScene = PauseScene(fileNamed: "PauseScene") {
                    pauseScene.scaleMode = .aspectFill
                    view?.presentScene(pauseScene, transition: .fade(withDuration: 0.5))
                } else {
                    let pauseScene = PauseScene(size: self.size)
                    pauseScene.scaleMode = .aspectFill
                    view?.presentScene(pauseScene, transition: .fade(withDuration: 0.5))
                }
            }
        }
    }
}
