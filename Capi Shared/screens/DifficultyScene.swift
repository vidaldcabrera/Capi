import SpriteKit
import GameplayKit

class DifficultyScene: SKScene {
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
        let localizedTitle = LocalizationManager.shared.localizedString(forKey: "difficulty")
        let titleLabel = FontFactory.makeTitle(localizedTitle, at: CGPoint(x: frame.midX, y: frame.midY + 150))
        titleLabel.zPosition = 15
        addChild(titleLabel)

        let buttons: [(String, String, CGFloat)] = [
            ("ButtonBoxUnselected", "easy", 0.15),
            ("ButtonBoxUnselected", "normal", -0.03),
            ("ButtonBoxUnselected", "extreme", -0.21)
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
        back.name = "backButton"
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
            switch node.name {
            case "backButton":
                VoiceOverManager.shared.speak(LocalizationManager.shared.localizedString(forKey: "back"))
                let scene = GameScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
                return
                
            case "easy":
                // Acontece algo
                break

            case "normal":
                // Acontece algo
                break
               
            case "extreme":
                // Acontece algo
                break

            default:
                break
            }
        }
    }


}
