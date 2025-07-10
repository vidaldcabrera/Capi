import Foundation
import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    let spriteNode: SKSpriteNode
    var moveComponent: MovementComponent? {
        component(ofType: MovementComponent.self)
    }
    
    override init() {
        // ⚠️ Se estiver usando Atlas:
        // let idleAtlas = SKTextureAtlas(named: "idle")
        // let firstTexture = idleAtlas.textureNamed("idle1.png")
        // spriteNode = SKSpriteNode(texture: firstTexture)

        spriteNode = SKSpriteNode(imageNamed: "idle1.png")
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.75)
        spriteNode.setScale(1.0)
        spriteNode.name = "player"
        
        // Física
        let body = SKPhysicsBody(rectangleOf: spriteNode.size)
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.usesPreciseCollisionDetection = true
        
        body.categoryBitMask = CollisionCategory.player
        body.contactTestBitMask = CollisionCategory.apple // e outros se quiser adicionar
//        body.collisionBitMask = CollisionCategory.ground  // se quiser

        
        spriteNode.physicsBody = body
        
        super.init()
        
        addComponent(GKSKNodeComponent(node: spriteNode))
        
        let idleAction = SKAction.repeatForever(.animate(with: .init(withFormat: "idle%@.png", range: 1...7), timePerFrame: 0.1))
        let runAction = SKAction.repeatForever(.animate(with: .init(withFormat: "walk%@.png", range: 1...7), timePerFrame: 0.1))
        
        addComponent(AnimationComponent(node: spriteNode, idleAction: idleAction, runAction: runAction))
        addComponent(MovementComponent(speed: 2.5))
        
        let jumpAtlas = SKTextureAtlas(named: "capiJump")
        let jumpFrames = (1...8).map { jumpAtlas.textureNamed("jump\($0).png") }
        let jumpComp = JumpComponent(node: spriteNode, frames: jumpFrames, impulse: CGVector(dx: 0, dy: 100))
        addComponent(jumpComp)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
