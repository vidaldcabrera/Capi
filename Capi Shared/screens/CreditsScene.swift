import SpriteKit
import GameplayKit

class CreditsScene: SKScene {
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
        let localizedTitle = LocalizationManager.shared.localizedString(forKey: "developers")
        let titleLabel = FontFactory.makeTitle(localizedTitle, at: CGPoint(x: frame.midX, y: frame.midY + 150))
        titleLabel.zPosition = 15
        addChild(titleLabel)

        // Nomes

        let cont = FontFactory.makeSubtitle("Cont", at: CGPoint(x: 0, y: 85))
        cont.zPosition = 15
        addChild(cont)
        
        let gabi = FontFactory.makeSubtitle("Gabi", at: CGPoint(x: 0, y: frame.midY + 40))
        gabi.zPosition = 15
        addChild(gabi)
        
        let vitor = FontFactory.makeSubtitle("Vitor", at: CGPoint(x: 0, y: frame.midY - 5))
        vitor.zPosition = 15
        addChild(vitor)
        
        let vidal = FontFactory.makeSubtitle("Vidal", at: CGPoint(x: 0, y: frame.midY - 50))
        vidal.zPosition = 15
        addChild(vidal)
        
        let murilo = FontFactory.makeSubtitle("Murilo", at: CGPoint(x: 0, y: frame.midY - 95))
        murilo.zPosition = 15
        addChild(murilo)
    

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
        let touchedNode = atPoint(location)

        if touchedNode.name == "backButton" {
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
        }
    }
}
