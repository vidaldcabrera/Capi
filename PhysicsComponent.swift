import SpriteKit
import GameplayKit

class PhysicsComponent: GKComponent {
    var body: SKPhysicsBody?

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurePhysicsBody(for node: SKNode, size: CGSize,
                              affectedByGravity: Bool = false,
                              allowsRotation: Bool = false,
                              isDynamic: Bool = true,
                              categoryBitMask: UInt32,
                              contactTestBitMask: UInt32,
                              collisionBitMask: UInt32)
    {
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.affectedByGravity = affectedByGravity
        physicsBody.allowsRotation = allowsRotation
        physicsBody.isDynamic = isDynamic
        physicsBody.categoryBitMask = categoryBitMask
        physicsBody.contactTestBitMask = contactTestBitMask
        physicsBody.collisionBitMask = collisionBitMask

        node.physicsBody = physicsBody
        self.body = physicsBody
    }
}
