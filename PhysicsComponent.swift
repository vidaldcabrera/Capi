import Foundation
import GameplayKit
import SpriteKit

class PhysicsComponent: GKComponent {
    unowned let node: SKNode
    private let categoryBitMask: UInt32
    private let contactTestBitMask: UInt32
    private let collisionBitMask: UInt32
    private let isDynamic: Bool
    private let allowsRotation: Bool

    init(node: SKNode,
         categoryBitMask: UInt32,
         contactTestBitMask: UInt32,
         collisionBitMask: UInt32,
         isDynamic: Bool = true,
         allowsRotation: Bool = false) {
        self.node = node
        self.categoryBitMask = categoryBitMask
        self.contactTestBitMask = contactTestBitMask
        self.collisionBitMask = collisionBitMask
        self.isDynamic = isDynamic
        self.allowsRotation = allowsRotation
        super.init()

        let body: SKPhysicsBody
        if let sprite = node as? SKSpriteNode, let texture = sprite.texture {
            body = SKPhysicsBody(texture: texture, size: sprite.size)
        } else {
            body = SKPhysicsBody(rectangleOf: node.frame.size)
        }
        body.isDynamic = isDynamic
        body.categoryBitMask = categoryBitMask
        body.contactTestBitMask = contactTestBitMask
        body.collisionBitMask = collisionBitMask
        body.allowsRotation = allowsRotation
        node.physicsBody = body
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


