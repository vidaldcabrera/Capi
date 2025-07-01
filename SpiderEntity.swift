import SpriteKit
import GameplayKit

class SpiderEntity: GKEntity {
    init(texture: SKTexture, position: CGPoint) {
        super.init()
        
        // 1) Render
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.position = position
        spriteNode.name = "spider"
        addComponent(GKSKNodeComponent(node: spriteNode))
        
        // 2) Física
        let physicsComp = PhysicsComponent(
            node: spriteNode,
            categoryBitMask: PhysicsCategory.spider,
            contactTestBitMask: PhysicsCategory.player | PhysicsCategory.playerAttack,
            collisionBitMask: 0,
            isDynamic: false,
            allowsRotation: false
        )
        addComponent(physicsComp)
        
        
        // 3) Estados
        let smComp = StateMachineComponent(states: [
            SpiderIdleState(entity: self),
            SpiderMoveState(entity: self),
            SpiderAttackState(entity: self),
            SpiderDeadState(entity: self)
        ])
        addComponent(smComp)
        smComp.stateMachine.enter(SpiderMoveState.self)
        
        // 4) Movimento
        addComponent(MovementComponent())
        
        // 5) Animações
        let idleAnima   = SKAction.repeatForever(.animate(with: .init(withFormat: "spider-idle-%d", range: 1...4), timePerFrame: 0.1))
        let walkAnima   = SKAction.repeatForever(.animate(with: .init(withFormat: "spider-walk-%d", range: 1...6), timePerFrame: 0.1))
        let attackAnima = SKAction.repeatForever(.animate(with: .init(withFormat: "spider-attack-%d", range: 1...6), timePerFrame: 0.1))
        let deathAnima  = SKAction.repeatForever(.animate(with: .init(withFormat: "spider-death-%d", range: 1...6), timePerFrame: 0.1))
        
        let animComp = AnimationComponent(node: spriteNode,
                                          idleAction: idleAnima,
                                          runAction:  walkAnima)
        animComp.addAnimation(named: "ataque", action: attackAnima)
        animComp.addAnimation(named: "morte",  action: deathAnima)
        addComponent(animComp)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
}
