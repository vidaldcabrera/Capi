import Foundation
import SpriteKit
import GameplayKit

enum Direction: CGFloat {
    case right = 1
    case left  = -1
    case none = 0
}

class MovementComponent: GKComponent {
    
    var node: SKNode?
    var speed: CGFloat
    var direction: Direction = .none
    var animationComp: AnimationComponent?
    
    var isJumping = false
    
    init(speed: CGFloat) {
        self.speed = speed
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    override func didAddToEntity() {
        node = entity?.component(ofType: GKSKNodeComponent.self)?.node
        animationComp = entity?.component(ofType: AnimationComponent.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        node?.position.x += direction.rawValue * speed
    }
    
    public func change(direction: Direction) {
        self.direction = direction
        
        if(direction == .none) {
            animationComp?.playIdle()
        } else {
            node?.xScale = abs(node?.xScale ?? 1) * direction.rawValue
            animationComp?.playRun()
        }
    }
    
    public func jump() {
            guard let body = node?.physicsBody else { return }

            // Verifica se está no chão (velocidade Y muito pequena)
            let isOnGround = abs(body.velocity.dy) < 1.0

            if isOnGround {
                body.applyImpulse(CGVector(dx: 0, dy: 30))
            }
        }
}
