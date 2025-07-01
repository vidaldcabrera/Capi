import Foundation
import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
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
        
        body.categoryBitMask = CollisionCategory.player
        body.contactTestBitMask = CollisionCategory.apple
        // colide com tudo que tiver fisica
        body.collisionBitMask = 0xFFFFFFFF
        body.usesPreciseCollisionDetection = true
        
        
        let animationComp = AnimationComponent(
            idleAction: .repeatForever(.    animate(with: .init(withFormat: "idle%@.png", range: 1...7), timePerFrame: 0.1)),
            runAction: .repeatForever(.animate(with: .init(withFormat: "walk%@.png", range: 1...7), timePerFrame: 0.1)))
        self.addComponent(animationComp)
        
        let moveComponent = MovementComponent(speed: 3)
        self.addComponent(moveComponent)
        
        
        // pulo 
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
