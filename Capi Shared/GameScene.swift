import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities: [GKEntity] = []
    var bat: BatEntity?
    private var lastTapTime: TimeInterval = 0
    private let doubleTapMaxDelay: TimeInterval = 0.3
    
    
    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            fatalError("Failed to load GameScene.sks")
        }
        scene.scaleMode = .aspectFill
        return scene
    }
    
    
    func setUpScene() {
        backgroundColor = .cyan
        // createPlayer()
        // createPlayerAttack()
        createSpider()
        
        // Cria o mosquito e adiciona na cena
        bat = BatEntity(position: CGPoint(x: -100, y: 100))
        
        if let batNode = bat?.spriteNode {
            addChild(batNode)
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        handleSpiderContact(contact)
        handleBatContact(contact)
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setUpScene()
    }
    
    private var lastUpdateTime: TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {
        
        for entity in entities {
            entity.update(deltaTime: currentTime)
        }
        var deltaTime = currentTime - lastUpdateTime
        if lastUpdateTime == 0 {
            deltaTime = 0
        }
        lastUpdateTime = currentTime
        bat?.batStateMachine.update(deltaTime: deltaTime)
    }
}

extension GameScene {

    func handleBatContact(_ contact: SKPhysicsContact){
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        // Garante sempre a mesma ordem: menor categoria primeiro
        if bodyA.categoryBitMask < bodyB.categoryBitMask {
            firstBody = bodyA
            secondBody = bodyB
        } else {
            firstBody = bodyB
            secondBody = bodyA
        }
        
        // Checa: Player tocando o morcego
        if firstBody.categoryBitMask == PhysicsCategory.player &&
            secondBody.categoryBitMask == PhysicsCategory.bat {
            
            if let batEntity = bat {
                batEntity.batStateMachine.enter(BatAttackingState.self)
            }
        }
        
    }
    
    func handleSpiderContact(_ contact: SKPhysicsContact){
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        var spiderNode: SKNode?
        var otherNode: SKNode?
        
        
        guard let nodeA = bodyA.node, let nodeB = bodyB.node else {
            return
        }
        
        
        if nodeA.name == "spider" {
            spiderNode = nodeA
            otherNode = nodeB
        } else if nodeB.name == "spider" {
            spiderNode = nodeB
            otherNode = nodeA
        } else {
            return // nenhum dos dois é aranha
        }
    
        
        guard let spiderEntity = spiderNode?.entity as? SpiderEntity else {
            return
        }
        
        
        if let stateMachineComponent = spiderEntity.component(ofType: StateMachineComponent.self) {
            if otherNode?.name == "player" {
                if !(stateMachineComponent.stateMachine.currentState is SpiderAttackState) {
                    print("colidiu")
                    stateMachineComponent.stateMachine.enter(SpiderAttackState.self)
                }
            } else if otherNode?.name == "playerAttack" {
                print("atacoueste")
                stateMachineComponent.stateMachine.enter(SpiderDeadState.self)
            }
        }
        
    }
    
    
    
    func createSpider() {
        let spiderTexture = SKTexture(imageNamed: "hat-man-idle-1")
        let spider = SpiderEntity(texture: spiderTexture, position: CGPoint(x: -30, y: -300))
        
        if let node = spider.component(ofType: RenderComponent.self)?.node {
            node.name = "spider"
            node.entity = spider
            addChild(node)
        }
        entities.append(spider)
    }

    
}


/*
func performPlayerAttack() {
    let attackNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: 30))
    attackNode.position = CGPoint(x: player.position.x, y: player.position.y)
    attackNode.name = "playerAttack"

    let physicsBody = SKPhysicsBody(rectangleOf: attackNode.size)
    physicsBody.affectedByGravity = false
    physicsBody.isDynamic = true
    physicsBody.categoryBitMask = PhysicsCategory.playerAttack
    physicsBody.contactTestBitMask = PhysicsCategory.spider
    physicsBody.collisionBitMask = 0

    attackNode.physicsBody = physicsBody

    let removeAfterDelay = SKAction.sequence([
        SKAction.wait(forDuration: 0.2),
        SKAction.removeFromParent()
    ])
    attackNode.run(removeAfterDelay)

    addChild(attackNode)
}

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let currentTime = CACurrentMediaTime()
    
    if currentTime - lastTapTime < doubleTapMaxDelay {
        // Detectou duplo clique -> ataque
        performPlayerAttack()
    } else {
        // Movimento normal
        if location.x < frame.midX {
            player.physicsBody?.applyImpulse(CGVector(dx: -20, dy: 0))
        } else {
            player.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 0))
        }
    }
    
    lastTapTime = currentTime
}
 */


/*
func createPlayer() {
    // Cria o sprite do jogador com cor e tamanho
    player = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
    player.position = CGPoint(x: 50, y: 70)
    player.name = "player"
    
    // Configura o corpo físico do jogador
    let physicsComponent = PhysicsComponent()
    physicsComponent.configurePhysicsBody(
        for: player,                                // Aplica a física nesse nó do jogador
           size: player.size,                          // Usa o tamanho do sprite como base do corpo
           affectedByGravity: true,                    // O jogador é afetado pela gravidade
           allowsRotation: false,                      // Evita que o jogador gire ao colidir
           categoryBitMask: PhysicsCategory.player,    // Define a categoria como 'player'
           contactTestBitMask: PhysicsCategory.ground | PhysicsCategory.spider,
           // Detecta contato com chão e aranha
           collisionBitMask: PhysicsCategory.ground | PhysicsCategory.spider
           // Colide fisicamente com o chão e com a aranha
    )
    addChild(player)
}


func createPlayerAttack() {
    // Cria uma hitbox de ataque do jogador
    let attackNode = SKSpriteNode(color: .clear, size: CGSize(width: 30, height: 30))
    
    // Posiciona na frente do jogador (ajuste conforme a direção do ataque)
    attackNode.position = CGPoint(x: player.position.x + 30, y: player.position.y)
    attackNode.name = "playerAttack"
    
    // Configura o corpo físico apenas para contato, sem colisão física
    let physicsBody = SKPhysicsBody(rectangleOf: attackNode.size)
    physicsBody.affectedByGravity = false
    physicsBody.isDynamic = true // Precisa ser dinâmico para gerar contato
    physicsBody.categoryBitMask = PhysicsCategory.playerAttack
    physicsBody.contactTestBitMask = PhysicsCategory.spider // Detecta aranha
    physicsBody.collisionBitMask = 0 // Não colide fisicamente com nada
    
    attackNode.physicsBody = physicsBody
    
    // Opcional: remova a hitbox após o ataque (0.2 segundos, por exemplo)
    let removeAfterDelay = SKAction.sequence([
        SKAction.wait(forDuration: 0.2),
        SKAction.removeFromParent()
    ])
    attackNode.run(removeAfterDelay)
    
    // Adiciona à cena
    addChild(attackNode)
}
*/
