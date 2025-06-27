import Foundation
import SpriteKit
import GameplayKit

enum Direction: CGFloat{
    case right = 1
    case left = -1
    case none = 0
}

class MovementComponent: GKComponent {
    
    var direction: CGFloat = 1
    let speed: CGFloat = 3
    let offset: CGFloat = 100
    var initialY: CGFloat?
    var node: SKNode?
    var speed: CGFloat
    var direction: Direction = .none
    var animationComp: AnimationComponent?
    var isJumping = false
    
    
    
    func spiderVerticalMovement() {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self),
              let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        
        let node = renderComponent.node
        
        if initialY == nil {
            initialY = node.position.y
        }
        
        guard let baseY = initialY else { return }
        
        // Troca a animação antes de começar a movimentar
        let currentAnimation = direction > 0 ? "subindo" : "descendo"
        animationComponent.runAnimation(named: currentAnimation)
        
        // Move
        node.position.y += direction * speed
        
        // Verifica limites e inverte direção
        if node.position.y >= baseY + offset {
            node.position.y = baseY + offset
            direction = -1
        } else if node.position.y <= baseY - offset {
            node.position.y = baseY - offset
            direction = 1
        }
    }
    
    
    func spiderIdleMovement(){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "parado")
    }
    
    func spiderAttackMovement(){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "ataque")
    }
    
    func spiderDeadMovement(){
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else { return }
        animationComponent.runAnimation(named: "morte")
    }
    
    
    init(speed: CGFloat) {
        self.speed = speed
        super.init()
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

