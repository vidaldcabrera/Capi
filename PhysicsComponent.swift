<<<<<<< HEAD
import SpriteKit
import GameplayKit

class PhysicsComponent: GKComponent {
    var body: SKPhysicsBody?
    
    override init() {
=======
import Foundation
import GameplayKit
import SpriteKit

class PhysicsComponent: GKComponent {
    
    var body: SKPhysicsBody
    
    init(physicsBody: SKPhysicsBody) {
        self.body = physicsBody
>>>>>>> feature/capi-mec
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
<<<<<<< HEAD
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
=======
    override func didAddToEntity() {
        if let node = self.entity?.component(ofType: GKSKNodeComponent.self)?.node {
            node.physicsBody = self.body
        }
    }
    
>>>>>>> feature/capi-mec
}
