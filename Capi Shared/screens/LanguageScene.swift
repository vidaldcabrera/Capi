import Foundation
import SpriteKit
import GameplayKit

class LanguageScene: SKScene {
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
        
        // Título
        let localizedTitle = LocalizationManager.shared.localizedString(forKey: "language")
        let titleLabel = FontFactory.makeTitle(localizedTitle, at: CGPoint(x: frame.midX, y: frame.midY + 150))
        titleLabel.zPosition = 15
        addChild(titleLabel)

                
        let buttons: [(String, String, CGFloat)] = [
            ("ButtonBoxUnselected", "english", 0.15),
            ("ButtonBoxUnselected", "portuguese", -0.03),
            ("ButtonBoxUnselected", "spanish", -0.21)
        ]

        for (nomeImage, name, relativeY) in buttons {
            let button = ButtonEntity(
                imageNamed: nomeImage,
                position: CGPoint(x: 0, y: view.frame.height * relativeY),
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


        let back = SKSpriteNode(imageNamed: "back_button")
        back.name = "back"
        back.position = CGPoint(x: 0, y: view.frame.height * -0.4)
        back.setScale(proportionalScale(view: view, multiplier: 0.35))
        back.zPosition = 6
        addChild(back)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        for node in nodes {
            guard let nodeName = node.name else { continue }
            switch node.name {
            case "back":
                VoiceOverManager.shared.speak(LocalizationManager.shared.localizedString(forKey: "back"))
                let settingsScene = SettingsScene(size: self.size)
                settingsScene.scaleMode = .aspectFill
                view?.presentScene(settingsScene, transition: .fade(withDuration: 0.5))

            case "english":
                handleButtonTouch(named: nodeName, at: location)
                LocalizationManager.shared.selectedLanguage = "en"
                reloadCurrentScene()

            case "portuguese":
                handleButtonTouch(named: nodeName, at: location)
                LocalizationManager.shared.selectedLanguage = "pt"
                reloadCurrentScene()

            case "spanish":
                handleButtonTouch(named: nodeName, at: location)
                LocalizationManager.shared.selectedLanguage = "es"
                reloadCurrentScene()

            default:
                break
            }
        }
    }

    func reloadCurrentScene() {
        let newScene = LanguageScene(size: self.size)
        newScene.scaleMode = .aspectFill
        view?.presentScene(newScene, transition: .fade(withDuration: 0.5))
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

