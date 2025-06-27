import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entityManager: SKEntityManager?
    private var lastUpdatedTime: TimeInterval = 0
    weak var playerEntity: PlayerEntity?
    var spawnPointPosition: CGPoint?
    var isRespawning = false

    
    static func newGameScene() -> GameScene {
        let size = UIScreen.main.bounds.size
        let scene = GameScene(size: size)
        return scene
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        entityManager = SKEntityManager(scene: self)
        
        let playerEntity = PlayerEntity()
        self.playerEntity = playerEntity
        
        // Carrega o cenario com SpawnPoint
        let sceneEntity = SceneEntity(named: "Scene1", entityManager: entityManager!)
        entityManager?.add(entity: sceneEntity)
        
        // Tenta encontrar o nó SpawnPoint
        if let scenarioNode = sceneEntity.component(ofType: GKSKNodeComponent.self)?.node,
           let spawnPoint = scenarioNode.childNode(withName: "//SpawnPoint") {
            
            spawnPointPosition = spawnPoint.position
            
            if let playerNode = playerEntity.component(ofType: GKSKNodeComponent.self)?.node {
                playerNode.position = spawnPoint.position
            }
        }
        
        
        // Adiciona o jogador a cena
        entityManager?.add(entity: playerEntity)
        // Camera
        let cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        self.camera = cameraNode
        self.camera?.setScale(1)
    }
    
    // Input por toque IOS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerEntity?.moveComponent?.change(direction: .none)
    }
    
    // Logica da camera e update
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdatedTime == 0 {
            lastUpdatedTime = currentTime
        }
        
        let dt = currentTime - lastUpdatedTime
        
        entityManager?.entities.forEach { $0.update(deltaTime: dt) }
        
        updateCameraFollow()
        
        lastUpdatedTime = currentTime
        
        // Verifica se o personagem caiu da tela
        if let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node,
           let spawn = spawnPointPosition,
           !isRespawning {

            if playerNode.position.y < -300 {
                isRespawning = true

                // Som de morte
                playerNode.run(SKAction.playSoundFileNamed("Death.mp3", waitForCompletion: false))

                // Animação de respawn com fade
                let respawnSequence = SKAction.sequence([
                    SKAction.fadeOut(withDuration: 0.1),
                    SKAction.wait(forDuration: 0.05),
                    SKAction.run {
                        playerNode.physicsBody?.velocity = .zero
                        playerNode.position = spawn
                    },
                    SKAction.fadeIn(withDuration: 0.1),
                    SKAction.run {
                        self.isRespawning = false
                    }
                ])

                playerNode.run(respawnSequence)
            }
        }
        
    }
    
    private func updateCameraFollow() {
        guard
            let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node,
            let camera = self.camera
        else { return }
        
        let screenSize = self.size
        let cameraLerpFactor: CGFloat = 0.3
        
        // Posicao do jogador na tela
        let desiredScreenX = screenSize.width * 0.25 // Esquerda
        let desiredScreenY = screenSize.height * 0.3  // Abaixo
        
        let cameraTargetX = playerNode.position.x + (screenSize.width / 2 - desiredScreenX)
        let cameraTargetY = playerNode.position.y + (screenSize.height / 2 - desiredScreenY)
        
        let targetPosition = CGPoint(x: cameraTargetX, y: cameraTargetY)
        let currentPosition = camera.position
        
        let lerpedPosition = CGPoint(
            x: currentPosition.x + (targetPosition.x - currentPosition.x) * cameraLerpFactor,
            y: currentPosition.y + (targetPosition.y - currentPosition.y) * cameraLerpFactor
        )
        
        camera.position = lerpedPosition
    }
    
    // Input por toque
    
    private func handleTouch(_ touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: self) else { return }
        
        // Toque parte superior, pula
        if location.y > size.height * 0.6 {
            playerEntity?.moveComponent?.change(direction: .none)
            playerEntity?.component(ofType: JumpComponent.self)?.jump()
            return
        }
        
        // Toque parte inferior, anda
        if location.x < frame.midX {
            playerEntity?.moveComponent?.change(direction: .left)
        } else {
            playerEntity?.moveComponent?.change(direction: .right)
        }
    }
}
