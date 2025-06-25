import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entityManager: SKEntityManager?
    private var lastUpdateTime : TimeInterval = 0
    weak var playerEntity: PlayerEntity?
    
    override func sceneDidLoad() {
        entityManager = SKEntityManager(scene: self)
        
        let playerEntity = PlayerEntity()
        entityManager?.add(entity: playerEntity)
        self.playerEntity = playerEntity
        
        let sceneEntity = SceneEntity(named: "Scene1", entityManager: entityManager!)
        entityManager?.add(entity: sceneEntity)
        
        let cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        self.camera?.setScale(0.5)
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
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdateTime
        
        if let entities = entityManager?.entities {
            for entity in entities {
                entity.update(deltaTime: dt)
            }
        }
        
        self.lastUpdateTime = currentTime
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
