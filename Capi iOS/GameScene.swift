import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

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
        self.physicsWorld.contactDelegate = self

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
        self.camera?.setScale(0.8)

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
