import Foundation
import SpriteKit
import GameplayKit

class GamePlayScene: SKScene {
    var enemySpawner: EnemySpawner!

    var entityManager: SKEntityManager!
    weak var playerEntity: PlayerEntity?
    var mosquito: MosquitoEntity?
    var bat: BatEntity?
    var spider: SpiderEntity?
    var spawnPointPosition: CGPoint?
    var isRespawning = false
    private var lastUpdatedTime: TimeInterval = 0


    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        entityManager = SKEntityManager(scene: self)

        // Adiciona HUD
        let hud = HUDOverlay()
        hud.name = "HUD"
        hud.position = CGPoint(x: 0, y: 0)
        hud.setupHUD(for: size)
        addChild(hud)

        // Cria playerEntity
        let player = PlayerEntity()
        playerEntity = player

        // Carrega cenário com SpawnPoint
        let sceneEntity = SceneEntity(named: "Scene1", entityManager: entityManager)
        entityManager.add(entity: sceneEntity)

        // Posiciona jogador no SpawnPoint
        if let scenarioNode = sceneEntity.component(ofType: GKSKNodeComponent.self)?.node,
           let spawnPoint = scenarioNode.childNode(withName: "//SpawnPoint"),
           let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node {
            
            spawnPointPosition = spawnPoint.position
            playerNode.position = spawnPoint.position
        }

        // Adiciona player à cena
        entityManager.add(entity: player)

        // Inimigos
        enemySpawner = EnemySpawner(scene: self, entityManager: entityManager)
        enemySpawner.spawnAll()

        bat = enemySpawner.bat
        mosquito = enemySpawner.mosquito
        spider = enemySpawner.spider


        // Câmera
        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
        camera?.setScale(1.8)

        // Animação de maçãs
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for entity in entityManager.entities {
            if let button = entity.component(ofType: ButtonComponent.self) {
                button.handleTouch(location: location)
            }
        }
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
}
