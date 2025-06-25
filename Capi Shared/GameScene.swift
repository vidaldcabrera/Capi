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
        captureInput(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerEntity?.moveComponent?.change(direction: .none)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        captureInput(touches: touches)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if self.lastUpdatedTime == 0 {
            self.lastUpdatedTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdatedTime
        
        let cameraOffset = CGPoint(x: 50, y: 50)
        let cameraLerpFactor: CGFloat = 0.4
        
        if let entities = entityManager?.entities {
            for entity in entities {
                entity.update(deltaTime: dt)
            }
        }
        
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
        
        self.lastUpdatedTime = currentTime
    }
    
    
    
    
    public func captureInput(touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: self) else { return }
        
        // Acima de 60% da altura, pula
        if location.y > size.height * 0.6 {
            playerEntity?.moveComponent?.change(direction: .none)
            playerEntity?
                .component(ofType: JumpComponent.self)?
                .jump()
            return
        }
        
        // Movimento
        if location.x <= frame.midX {
            // Cliquei mais para esquerdo
            playerEntity?.moveComponent?.change(direction: .left)
        } else {
            // Cliquei mais para direita
            playerEntity?.moveComponent?.change(direction: .right)
        }
    }
    
}


