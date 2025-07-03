import Foundation
import SpriteKit
import GameplayKit

class PauseScene: SKScene {
    var entityManager = SKEntityManager()
    
    override func didMove(to view: SKView) {
        //        backgroundColor = .black
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
        
        
        // Título
        let localizedTitle = LocalizationManager.shared.localizedString(forKey: "paused")
        let titleLabel = FontFactory.makeTitle(localizedTitle, at: CGPoint(x: frame.midX, y: frame.midY + 150))
        titleLabel.zPosition = 15
        addChild(titleLabel)
        
        // resume restart settings
        
        
        
        let buttons: [(String, String, CGFloat)] = [
            ("ButtonBoxUnselected", "resume", 90),
            ("ButtonBoxUnselected", "restart", 10),
            ("ButtonBoxUnselected", "settings", -70),
            ("ButtonBoxUnselected", "quit", -150)
        ]
        
        for (nomeImage, name, relativeY) in buttons {
            let button = ButtonEntity(
                imageNamed: nomeImage,
                position: CGPoint(x: frame.midX, y: frame.midY + relativeY),
                name: name,
                title: LocalizationManager.shared.localizedString(forKey: name),
                action: {} // vazio, pois o toque é tratado no `touchesBegan`
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
        let nodes = nodes(at: location)
        
        for node in nodes {
            guard let nodeName = node.name else { continue }
            switch node.name {
            case "resume":
                handleButtonTouch(named: nodeName, at: location)
                let resumeScene = GamePlayScene(size: self.size)
                resumeScene.scaleMode = .aspectFill
                view?.presentScene(resumeScene, transition: .fade(withDuration: 0.5))
                return
                
            case "restart":
                handleButtonTouch(named: nodeName, at: location)
                let restartScene = GameScene(size: self.size)
                restartScene.scaleMode = .aspectFill
                view?.presentScene(restartScene, transition: .fade(withDuration: 0.6))
                return
                
            case "settings":
                handleButtonTouch(named: nodeName, at: location)
                let settingsPauseScene = SettingsPauseScene(size: self.size)
                settingsPauseScene.scaleMode = .aspectFill
                view?.presentScene(settingsPauseScene, transition: .fade(withDuration: 0.6))
                return
                
            case "quit":
                handleButtonTouch(named: nodeName, at: location)
                exit(0)
                
            default:
                break
            }
        }
    }
    
    func handleButtonTouch(named nodeName: String, at location: CGPoint) {
        if let entity = entityManager.entities.first(where: {
            $0.component(ofType: GKSKNodeComponent.self)?.node.name == nodeName
        }),
        let button = entity.component(ofType: ButtonComponent.self) {
            button.handleTouch(location: location)
        }
    }
    
}
