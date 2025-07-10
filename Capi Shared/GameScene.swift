import SpriteKit
import GameplayKit
import Foundation

func proportionalScale(view: SKView, baseWidth: CGFloat = 390.0, multiplier: CGFloat) -> CGFloat {
    return (view.frame.width / baseWidth) * multiplier
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entityManager: SKEntityManager!

    private var lastUpdatedTime: TimeInterval = 0
    var spawnPointPosition: CGPoint?
    var isRespawning = false
    
    static func newGameScene(size: CGSize) -> GameScene {
        return GameScene(size: size)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        entityManager = SKEntityManager(scene: self)

        MusicManager.shared.playMusic(named: "background_music")
        
        let savedMusicVolume = UserDefaults.standard.float(forKey: "musicVolume")
        let initialMusicVolume = savedMusicVolume == 0 ? 0.5 : savedMusicVolume
        MusicManager.shared.setVolume(to: CGFloat(initialMusicVolume))
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .black
        
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
        
        let title = SKSpriteNode(imageNamed: "title")
        title.position = CGPoint(x: 0, y: view.frame.height * 0.45)
        title.setScale(proportionalScale(view: view, multiplier: 0.7))
        title.zPosition = 0
        addChild(title)
        
        let buttons: [(String, String, CGFloat, () -> Void)] = [
            ("ButtonBoxUnselected", "start", 0.1, {
                // ✅ RESETAR VIDAS ANTES DE INICIAR O JOGO
                GameState.shared.lives = 3

                let scene = LevelScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("ButtonBoxUnselected", "options", -0.14, {
                let scene = SettingsScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("ButtonBoxUnselected", "difficulty", -0.37, {
                let scene = DifficultyScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            }),
            ("ButtonBoxUnselected", "credits", -0.6, {
                let scene = CreditsScene(size: self.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: .fade(withDuration: 1))
            })
        ]
        
        for (nomeImage, name, relativeY, action) in buttons {
            let button = ButtonEntity(
                imageNamed: nomeImage,
                position: CGPoint(x: 0, y: view.frame.height * relativeY),
                name: name,
                title: LocalizationManager.shared.localizedString(forKey: name),
                action: action
            )
            entityManager.add(entity: button)
            if let node = button.component(ofType: GKSKNodeComponent.self)?.node {
                node.setScale(proportionalScale(view: view, multiplier: 0.4))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }

        for entity in entityManager.entities {
            if let button = entity.component(ofType: ButtonComponent.self) {
                button.handleTouch(location: location)
            }
        }
    }
}

