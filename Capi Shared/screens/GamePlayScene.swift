import Foundation
import SpriteKit
import GameplayKit

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
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
        backgroundColor = .black
        physicsWorld.contactDelegate = self


        // Cria e posiciona a câmera
        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
        camera?.setScale(0.5)

        // Adiciona HUD à câmera
        let hud = HUDOverlay()
        hud.name = "HUD"
        hud.setupHUD(for: size)
        hud.position = .zero
        hud.setScale(0.8)
        cameraNode.addChild(hud)

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

                // ⬇️ SUBTRAI 1 DO SCORE (SEM NEGATIVO)
                GameState.shared.score = max(0, GameState.shared.score + 1)

                // ⬇️ ATUALIZA O HUD
                if let hud = camera?.childNode(withName: "HUD") as? HUDOverlay {
                    hud.updateScore(to: GameState.shared.score)
                }
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
                
                // Atualiza GameState e HUD
                GameState.shared.lives -= 1
                if GameState.shared.lives <= 0 {
                    // Zera o score ao morrer
                    GameState.shared.score = 0

                    // Transição para o menu inicial
                    let transition = SKTransition.fade(withDuration: 0.5)
                    let mainMenu = GameScene(size: size)
                    mainMenu.scaleMode = .aspectFill
                    view?.presentScene(mainMenu, transition: transition)
                    return
                }
                updateLifes()

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
    func updateLifes() {
        if let hud = camera?.childNode(withName: "HUD") as? HUDOverlay {
            hud.updateLives(to: GameState.shared.lives)
        }
    }


    // Câmera segue o jogador diretamente
    private func updateCameraFollow() {
        guard let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node else { return }
        camera?.position = playerNode.position
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



