import Foundation
import SpriteKit
import GameplayKit

class JumpComponent: GKComponent {
    weak var node: SKSpriteNode?
    private let jumpFrames: [SKTexture]
    private let jumpImpulse: CGVector
    private var isJumping = false
    
    init(node: SKSpriteNode,
         frames: [SKTexture],
         impulse: CGVector = CGVector(dx: 0, dy: 300)) {
        self.node = node
        self.jumpFrames = frames
        self.jumpImpulse = impulse
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
    func canJump() -> Bool {
        guard let body = node?.physicsBody else { return false}
        return abs(body.velocity.dy) < 1.0 && !isJumping
    }
    
    func jump() {
        guard canJump(), let node = node else { return }
        isJumping = true
        
        // Impulso vertical
        node.physicsBody?.applyImpulse(jumpImpulse)
        
        // Animação de pulo
        let jump = SKAction.animate(
            with: jumpFrames,
            timePerFrame: 0.1,
            resize: false,
            restore: false
        )
        node.run(jump) { [weak self] in
            self?.isJumping = false
        }
    }
}
