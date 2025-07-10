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

        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
        camera?.setScale(0.5)

        let hud = HUDOverlay()
        hud.name = "HUD"
        hud.setupHUD(for: size)
        hud.position = .zero
        hud.setScale(0.8)
        cameraNode.addChild(hud)

        let player = PlayerEntity()
        playerEntity = player

        let sceneEntity = SceneEntity(named: "Scene1", entityManager: entityManager)
        entityManager.add(entity: sceneEntity)

        if let scenarioNode = sceneEntity.component(ofType: GKSKNodeComponent.self)?.node,
           let spawnPoint = scenarioNode.childNode(withName: "//SpawnPoint"),
           let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node {
            spawnPointPosition = spawnPoint.position
            playerNode.position = spawnPoint.position
        }

        entityManager.add(entity: player)

        enemySpawner = EnemySpawner(scene: self, entityManager: entityManager)
        enemySpawner.spawnAll()
        bat = enemySpawner.bat
        mosquito = enemySpawner.mosquito
        spider = enemySpawner.spider

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

                GameState.shared.score = max(0, GameState.shared.score + 1)

                if let hud = camera?.childNode(withName: "HUD") as? HUDOverlay {
                    hud.updateScore(to: GameState.shared.score)
                }
            }
        }

        // Verifica se houve contato com inimigos
        handleEnemyContact(contact, enemyName: "mosquito")
        handleEnemyContact(contact, enemyName: "bat")
        handleEnemyContact(contact, enemyName: "spider")
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
            node.name = "apple"
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

        if let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node,
           let spawn = spawnPointPosition,
           !isRespawning {

            if playerNode.position.y < -300 {
                loseLifeAndRespawn()
            }
        }
    }

    func updateLifes() {
        if let hud = camera?.childNode(withName: "HUD") as? HUDOverlay {
            hud.updateLives(to: GameState.shared.lives)
        }
    }

    private func updateCameraFollow() {
        guard let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node else { return }
        camera?.position = playerNode.position
    }

    private func sortedBodies(_ contact: SKPhysicsContact) -> (first: SKPhysicsBody, second: SKPhysicsBody) {
        return contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
            ? (contact.bodyA, contact.bodyB)
            : (contact.bodyB, contact.bodyA)
    }

    private func handleEnemyContact(_ contact: SKPhysicsContact, enemyName: String) {
        let bodies = sortedBodies(contact)
        guard let nodeA = bodies.first.node, let nodeB = bodies.second.node else { return }
        
        // Verifica nomes dos nós
        guard let nameA = nodeA.name, let nameB = nodeB.name else { return }

        // Verifica se é uma colisão entre jogador e o inimigo esperado
        let isValidContact = (nameA == enemyName && nameB == "player") || (nameB == enemyName && nameA == "player")
        guard isValidContact, !isRespawning else { return }

        let enemyNode = (nameA == enemyName) ? nodeA : nodeB

        loseLifeAndRespawn()

        // Estado de ataque por tipo
        switch enemyName {
        case "bat":
            bat?.batStateMachine.enter(BatAttackingState.self)
        case "mosquito":
            mosquito?.mosquitoStateMachine.enter(MosquitoAttackingState.self)
        case "spider":
            if let spiderEntity = enemyNode.entity as? SpiderEntity,
               let sm = spiderEntity.component(ofType: StateMachineComponent.self)?.stateMachine {
                sm.enter(SpiderAttackState.self)
            }
        default:
            break
        }
    }


    private func loseLifeAndRespawn() {
        isRespawning = true
        GameState.shared.lives -= 1
        updateLifes()

        if GameState.shared.lives <= 0 {
            GameState.shared.score = 0
            let transition = SKTransition.fade(withDuration: 0.5)
            let mainMenu = GameScene(size: size)
            mainMenu.scaleMode = .aspectFill
            view?.presentScene(mainMenu, transition: transition)
            return
        }

        if let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node,
           let spawn = spawnPointPosition {
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
            playerNode.run(respawnSequence)
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

