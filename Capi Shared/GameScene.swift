import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var entityManager: SKEntityManager!
    weak var playerEntity: PlayerEntity?
    var mosquito: MosquitoEntity?
    var bat: BatEntity?
    private var lastUpdateTime: TimeInterval = 0

    static func newGameScene() -> GameScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        return scene
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)

        entityManager = SKEntityManager(scene: self)

        let player = PlayerEntity(position: CGPoint(x: 0, y: 0))
        entityManager.add(entity: player)
        playerEntity = player

        let sceneEnt = SceneEntity(named: "Scene1", entityManager: entityManager)
        entityManager.add(entity: sceneEnt)

        createSpider()
        createBat()
        createMosquito()

        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
    }

    override func update(_ currentTime: TimeInterval) {
        let dt = lastUpdateTime == 0 ? 0 : currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        for ent in entityManager.entities {
            ent.update(deltaTime: dt)
        }
        bat?.batStateMachine.update(deltaTime: dt)
        mosquito?.mosquitoStateMachine.update(deltaTime: dt)
        updateCamera()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        handleBatContact(contact)
        handleSpiderContact(contact)
        handleMosquitoContact(contact)
    }

    private func updateCamera() {
        let offset = CGPoint(x: 50, y: 50)
        let lerpFactor: CGFloat = 0.4
        guard let playerNode = playerEntity?.component(ofType: GKSKNodeComponent.self)?.node,
              let cam = camera else { return }
        let target = CGPoint(x: playerNode.position.x + offset.x,
                             y: playerNode.position.y + offset.y)
        cam.position = CGPoint(
            x: cam.position.x + (target.x - cam.position.x) * lerpFactor,
            y: cam.position.y + (target.y - cam.position.y) * lerpFactor
        )
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
        captureInput(touches: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        captureInput(touches: touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerEntity?.moveComponent?.change(direction: .none)
    }

    private func captureInput(touches: Set<UITouch>) {
        guard let loc = touches.first?.location(in: self) else { return }
        if loc.y > size.height * 0.6 {
            playerEntity?.component(ofType: JumpComponent.self)?.jump()
        } else {
            let dir: Direction = loc.x <= frame.midX ? .left : .right
            playerEntity?.moveComponent?.change(direction: dir)
        }
    }
}
