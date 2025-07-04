import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var entityManager: SKEntityManager!
    weak var playerEntity: PlayerEntity?
    var mosquito: MosquitoEntity?
    var bat: BatEntity?
    private var lastUpdatedTime: TimeInterval = 0
    var spawnPointPosition: CGPoint?
    var isRespawning = false
    
    static func newGameScene() -> GameScene {
        let size = UIScreen.main.bounds.size
        let scene = GameScene(size: size)
        return scene
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        entityManager = SKEntityManager(scene: self)
        
        let player = PlayerEntity()
        playerEntity = player
        
        // Carrega o cenario com SpawnPoint
        
        
        let sceneEntity = SceneEntity(named: "Scene1", entityManager: entityManager)
        entityManager?.add(entity: sceneEntity)
        
        // Tenta encontrar o nó SpawnPoint
        
        if let scenarioNode = sceneEntity.component(ofType: GKSKNodeComponent.self)?.node,
           let spawnPoint = scenarioNode.childNode(withName: "//SpawnPoint") {
            
            spawnPointPosition = spawnPoint.position
            
            if let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node {
                playerNode.position = spawnPoint.position
            }
        }
        
        // Adiciona o jogador a cena
        entityManager?.add(entity: player)
        
        // player.component(ofType: AnimationComponent)
        
        createSpider()
        createBat()
        createMosquito()
        
        
        // Camera
        let cameraNode = SKCameraNode()
        
        addChild(cameraNode)
        camera = cameraNode
        camera?.setScale(1.8)
        
        // Aguarda um momento e inicia animação
        run(.wait(forDuration: 0.1)) { [weak self] in
            self?.animateCollectibles()
        }
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contato detectado")

        let bodies = [contact.bodyA, contact.bodyB]

        if bodies.contains(where: { $0.categoryBitMask == CollisionCategory.player }) &&
            bodies.contains(where: { $0.categoryBitMask == CollisionCategory.apple }) {

            print("Coletando maçã")

            if let fruit = bodies.first(where: { $0.categoryBitMask == CollisionCategory.apple })?.node {
                fruit.run(SKAction.sequence([
                    SKAction.scale(to: 0.0, duration: 0.1),
                    SKAction.removeFromParent()
                ]))

                
            }
        }
        
        
        handleBatContact(contact)
        handleSpiderContact(contact)
        handleMosquitoContact(contact)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdatedTime == 0 {
            lastUpdatedTime = currentTime
        }

        let dt = currentTime - lastUpdatedTime

        entityManager?.update(dt)


        updateCameraFollow()

        lastUpdatedTime = currentTime

        // Verifica se o personagem caiu da tela
        if let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node,
           let spawn = spawnPointPosition,
           !isRespawning {

            if playerNode.position.y < -300 {
                isRespawning = true

                playerNode.run(SKAction.playSoundFileNamed("Death.mp3", waitForCompletion: false))

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
                
                  bat?.batStateMachine.update(deltaTime: dt)
                  mosquito?.mosquitoStateMachine.update(deltaTime: dt)
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

        let desiredScreenX = screenSize.width * 0.25
        let desiredScreenY = screenSize.height * 0.3

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
    
    private func sortedBodies(_ contact: SKPhysicsContact) -> (first: SKPhysicsBody, second: SKPhysicsBody) {
        return contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        ? (contact.bodyA, contact.bodyB)
        : (contact.bodyB, contact.bodyA)
    }
    
    private func handleBatContact(_ contact: SKPhysicsContact) {
        let bodies = sortedBodies(contact)
        if bodies.first.categoryBitMask == PhysicsCategory.player &&
            bodies.second.categoryBitMask == PhysicsCategory.bat {
            bat?.batStateMachine.enter(BatAttackingState.self)
        }
    }
    
    private func handleSpiderContact(_ contact: SKPhysicsContact) {
        let bodies = sortedBodies(contact)
        guard let nodeA = bodies.first.node, let nodeB = bodies.second.node else { return }
        let (spiderNode, otherNode) = nodeA.name == "spider" ? (nodeA, nodeB) : (nodeB, nodeA)
        if let spiderEntity = spiderNode.entity as? SpiderEntity,
           let sm = spiderEntity.component(ofType: StateMachineComponent.self)?.stateMachine {
            if otherNode.name == "player",
               !(sm.currentState is SpiderAttackState) {
                sm.enter(SpiderAttackState.self)
            } else if otherNode.name == "playerAttack" {
                sm.enter(SpiderDeadState.self)
            }
        }
    }
    
    private func handleMosquitoContact(_ contact: SKPhysicsContact) {
        let bodies = sortedBodies(contact)
        if bodies.first.categoryBitMask == PhysicsCategory.player &&
            bodies.second.categoryBitMask == PhysicsCategory.mosquito {
            mosquito?.mosquitoStateMachine.enter(MosquitoAttackingState.self)
        }
    }
    
    private func createSpider() {
        let texture = SKTexture(imageNamed: "hat-man-idle-1")
        let spider = SpiderEntity(texture: texture, position: CGPoint(x: -30, y: -30))
        entityManager.add(entity: spider)
    }
    
    private func createBat() {
        bat = BatEntity(position: CGPoint(x: -100, y: 50))
        if let node = bat?.spriteNode {
            addChild(node)
        }
    }
    
    private func createMosquito() {
        mosquito = MosquitoEntity(position: CGPoint(x: 100, y: 50))
        if let node = mosquito?.spriteNode {
            addChild(node)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerEntity?.moveComponent?.change(direction: .none)
    }
    
    private func handleTouch(_ touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: self) else { return }

        if location.y > size.height * 0.6 {
            playerEntity?.moveComponent?.change(direction: .none)
            playerEntity?.component(ofType: JumpComponent.self)?.jump()
            return
        }

        if location.x < frame.midX {
            playerEntity?.moveComponent?.change(direction: .left)
        } else {
            playerEntity?.moveComponent?.change(direction: .right)
        }
    }
    
    func animateCollectibles() {
        let textures = (1...17).compactMap { SKTexture(imageNamed: "apple\($0)") }
        let animation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.05))

        guard let sceneEntity = entityManager?.entities.first(where: { $0 is SceneEntity }),
              let sceneNode = sceneEntity.component(ofType: GKSKNodeComponent.self)?.node else {
            print("⚠️ SceneEntity ou nó raiz não encontrados")
            return
        }

        var count = 0
        sceneNode.enumerateChildNodes(withName: "//apple") { node, _ in
            count += 1
            print("🍎 Maçã encontrada (\(count))")

            node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionCategory.apple
            node.physicsBody?.contactTestBitMask = CollisionCategory.player
            node.physicsBody?.collisionBitMask = 0
            node.run(animation)
        }

        print("🍏 Total de maçãs animadas: \(count)")
    }
}
