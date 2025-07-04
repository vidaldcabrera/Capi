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
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.2)
        spriteNode.setScale(1)
        spriteNode.name = "player"
        
        // Física
        let body = SKPhysicsBody(rectangleOf: spriteNode.size)
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.usesPreciseCollisionDetection = true
        
        body.categoryBitMask = PhysicsCategory.player
        body.contactTestBitMask = PhysicsCategory.mosquito | PhysicsCategory.bat | CollisionCategory.apple
        body.collisionBitMask = 0xFFFFFFFF
        
        spriteNode.physicsBody = body
        
        super.init()
        
        addComponent(GKSKNodeComponent(node: spriteNode))
        
        let idleAction = SKAction.repeatForever(.animate(with: .init(withFormat: "idle%@.png", range: 1...7), timePerFrame: 0.1))
        let runAction = SKAction.repeatForever(.animate(with: .init(withFormat: "walk%@.png", range: 1...7), timePerFrame: 0.1))
        
        addComponent(AnimationComponent(node: spriteNode, idleAction: idleAction, runAction: runAction))
        addComponent(MovementComponent(speed: 3))
        
        let jumpAtlas = SKTextureAtlas(named: "capijump")
        let jumpFrames = (1...8).map { jumpAtlas.textureNamed("jump\($0).png") }
        let jumpComp = JumpComponent(node: spriteNode, frames: jumpFrames, impulse: CGVector(dx: 0, dy: 350))
        addComponent(jumpComp)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
