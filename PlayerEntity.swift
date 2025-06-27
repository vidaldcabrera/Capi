import Foundation
import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
<<<<<<< HEAD
    let spriteNode: SKSpriteNode
    
    init(position: CGPoint) {
        // Cria um quadrado azul simples como placeholder do player
        spriteNode = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 40))
        spriteNode.position = position
        spriteNode.name = "player"
        
        // Configura o physicsBody do player
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.isDynamic = true
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.player
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.mosquito | PhysicsCategory.bat
        spriteNode.physicsBody?.collisionBitMask = PhysicsCategory.ground // Só colide com o chão, por exemplo
        
        super.init()
=======
    var moveComponent: MovementComponent? {
        return component(ofType: MovementComponent.self)
    }
    
    override init() {
        super.init()
        let node = SKSpriteNode(imageNamed: "idle1.png")

        node.anchorPoint = .init(x: 0.5, y: 0.20)
        node.setScale(1)
        self.addComponent(GKSKNodeComponent(node: node))
        
        
        let size: CGSize = .init(width: 32 , height: 32)
        let body = SKPhysicsBody(rectangleOf: size, center: .init(x: 0, y: size.height/2))
        self.addComponent(PhysicsComponent(physicsBody: body))
        body.isDynamic = true
        body.affectedByGravity = true

        body.allowsRotation = false
        
        let animationComp = AnimationComponent(
            idleAction: .repeatForever(.animate(with: .init(withFormat: "idle%@.png", range: 1...7), timePerFrame: 0.1)),
            runAction: .repeatForever(.animate(with: .init(withFormat: "walk%@.png", range: 1...7), timePerFrame: 0.1)))
        self.addComponent(animationComp)
        
        let moveComponent = MovementComponent(speed: 3)
        self.addComponent(moveComponent)

        
        // MARK: - Pulo
        let jumpAtlas = SKTextureAtlas(named: "capijump")
        let jumpFrames: [SKTexture] = (1...8).map { i in
            jumpAtlas.textureNamed("jump\(i).png")
        }
        let jumpComp = JumpComponent(
            node: node,
            frames: jumpFrames,
            impulse: CGVector(dx: 0, dy: 350)
        )
        self.addComponent(jumpComp)
>>>>>>> feature/capi-mec
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
<<<<<<< HEAD
=======
    
>>>>>>> feature/capi-mec
}
