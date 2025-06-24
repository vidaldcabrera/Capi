import SpriteKit
import GameplayKit

class JumpComponent: GKComponent {
    let spriteNode: SKSpriteNode
    private let jumpImpulse = CGVector(dx: 0, dy: 400)
    var isOnGround = false
    
    init(spriteNode: SKSpriteNode) {
        self.spriteNode = spriteNode
        super.init()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func jump() {
        guard isOnGround else { return }
        spriteNode.physicsBody?.applyImpulse(jumpImpulse)
        isOnGround = false
    }
}
