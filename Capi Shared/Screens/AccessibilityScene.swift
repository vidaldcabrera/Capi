

import Foundation
import SpriteKit
import GameplayKit

class AccessibilityScene: SKScene {
    var entityManager: SKEntityManager!
    
    override func didMove(to view: SKView) {
        self.entityManager = SKEntityManager(scene: self)
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
        let localizedTitle = LocalizationManager.shared.localizedString(forKey: "accessibility")
        let titleLabel = FontFactory.makeTitle(localizedTitle, at: CGPoint(x: frame.midX, y: frame.midY + 150))
        titleLabel.zPosition = 15
        addChild(titleLabel)
        
    

        let localizedSubtitle = LocalizationManager.shared.localizedString(forKey: "voiceover")
        let subtitleLabel = FontFactory.makeSubtitle(localizedSubtitle, at: CGPoint(x: frame.midX - 100, y: frame.midY + 60))
        subtitleLabel.zPosition = 15
        addChild(subtitleLabel)

        // Button VoiceOver enable e disable
        let accessibilityButton = SKSpriteNode(imageNamed: "ButtonBoxUnselected")
        accessibilityButton.name = "voiceover"
        accessibilityButton.position = CGPoint(x: frame.midX + 100, y: frame.midY + 60)
        accessibilityButton.setScale(0.8)
        accessibilityButton.zPosition = 15
        addChild(accessibilityButton)

        // Atualiza para refletir o estado salvo
        VoiceOverManager.shared.updateAccessibilityButton(accessibilityButton)

    
        
        
        
        
        
        
        
        
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
            if node.name == "back" {
                VoiceOverManager.shared.speak(LocalizationManager.shared.localizedString(forKey: "back"))

                if let settingsPauseScene = SettingsPauseScene(fileNamed: "SettingsPauseScene") {
                    settingsPauseScene.scaleMode = .aspectFill
                    view?.presentScene(settingsPauseScene, transition: .fade(withDuration: 0.5))
                } else {
                    let settingsPauseScene = SettingsPauseScene(size: self.size)
                    settingsPauseScene.scaleMode = .aspectFill
                    view?.presentScene(settingsPauseScene, transition: .fade(withDuration: 0.5))
                }
            }
            
            else if node.name == "voiceover" {
                
                let newStatus = !VoiceOverManager.shared.isVoiceOverEnabled

                let statusKey = newStatus ? "voiceover_enabled" : "voiceover_disabled"
                let statusMessage = LocalizationManager.shared.localizedString(forKey: statusKey)

                VoiceOverManager.shared.speak(statusMessage, force: true)
                VoiceOverManager.shared.isVoiceOverEnabled = newStatus

                if let button = node as? SKSpriteNode {
                    VoiceOverManager.shared.updateAccessibilityButton(button)
                }
            }



        }
    }
}
