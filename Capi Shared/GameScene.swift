import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entityManager: SKEntityManager?
    private var lastUpdatedTime : TimeInterval = 0
    weak var playerEntity : PlayerEntity?
    
    static func newGameScene() -> GameScene {
        // 1) Define o tamanho baseado na tela
        let size = UIScreen.main.bounds.size
        let scene = GameScene(size: size)
       

        return scene
    }
   
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
      

        entityManager = SKEntityManager(scene: self)

        let playerEntity = PlayerEntity()
        entityManager?.add(entity: playerEntity)
        self.playerEntity = playerEntity

        let sceneEntity = SceneEntity(named: "Scene1", entityManager: entityManager!)
        entityManager?.add(entity: sceneEntity)

        let cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        self.camera = cameraNode
        self.camera?.setScale(1)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            if location.x <= 0 {
                // Cliquei mais para esquerda
                playerEntity?.moveComponent?.change(direction: .left)
            } else {
                // Cliquei mais para direita
                playerEntity?.moveComponent?.change(direction: .right)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerEntity?.moveComponent?.change(direction: .none)
    }
    
    let cameraOffset = CGPoint(x: 50, y: 50)
    let cameraLerpFactor: CGFloat = 0.4

    override func update(_ currentTime: TimeInterval) {
        if self.lastUpdatedTime == 0 {
            self.lastUpdatedTime = currentTime
        }

        let dt = currentTime - self.lastUpdatedTime

        if let entities = entityManager?.entities {
            for entity in entities {
                entity.update(deltaTime: dt)
            }
        }

        self.lastUpdatedTime = currentTime

        // 🟢 Suavização da câmera
        if let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node,
           let camera = self.camera {

            let targetPosition = CGPoint(
                x: playerNode.position.x + cameraOffset.x,
                y: playerNode.position.y + cameraOffset.y
            )

            let currentPosition = camera.position

            let lerpedPosition = CGPoint(
                x: currentPosition.x + (targetPosition.x - currentPosition.x) * cameraLerpFactor,
                y: currentPosition.y + (targetPosition.y - currentPosition.y) * cameraLerpFactor
            )

            camera.position = lerpedPosition
        }
    }
}


