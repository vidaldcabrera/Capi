import Foundation
import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    let spriteNode: SKSpriteNode
    var moveComponent: MovementComponent? {
        component(ofType: MovementComponent.self)
    }

    init(position: CGPoint) {
        // Configura o sprite do jogador
        spriteNode = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 40))
        spriteNode.position = position
        spriteNode.name = "player"
        
        // Configuração de física
        let body = SKPhysicsBody(rectangleOf: spriteNode.size)
        body.isDynamic = true
        body.categoryBitMask = PhysicsCategory.player
        body.contactTestBitMask = PhysicsCategory.mosquito | PhysicsCategory.bat
        body.collisionBitMask = PhysicsCategory.ground
        body.allowsRotation = false
        
        // MARK: -Debugando
        body.affectedByGravity = false
        spriteNode.physicsBody = body

        super.init()

        // Componente de nó para adicionar o sprite à cena
        addComponent(GKSKNodeComponent(node: spriteNode))

        // Animações
        let idleAction = SKAction.repeatForever(
            .animate(with: .init(withFormat: "idle%@.png", range: 1...7), timePerFrame: 0.1)
        )
        let runAction = SKAction.repeatForever(
            .animate(with: .init(withFormat: "walk%@.png", range: 1...7), timePerFrame: 0.1)
        )
        let animationComp = AnimationComponent(node:spriteNode, idleAction: idleAction, runAction: runAction)
        addComponent(animationComp)

        // Movimento
        let moveComp = MovementComponent(speed: 3)
        addComponent(moveComp)

        // Pulo
        let jumpAtlas = SKTextureAtlas(named: "capijump")
        let jumpFrames: [SKTexture] = (1...8).map { jumpAtlas.textureNamed("jump\($0).png") }
        let jumpComp = JumpComponent(
            node: spriteNode,
            frames: jumpFrames,
            impulse: CGVector(dx: 0, dy: 50)
        )
        addComponent(jumpComp)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


