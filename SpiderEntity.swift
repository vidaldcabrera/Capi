import Foundation
import SpriteKit
import GameplayKit

class SpiderEntity: GKEntity, CollisionHandler {
    weak var stateMachineComponent: StateMachineComponent?
    
    init(texture: SKTexture, position: CGPoint) {
        super.init()
        
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.position = position
        spriteNode.name = "spider"
        
        let renderComponent = RenderComponent(node: spriteNode)
        
        
        addComponent(renderComponent)
        
        let physicsComponent = PhysicsComponent()
        physicsComponent.configurePhysicsBody(
            for: spriteNode,                         // Aplica o SKPhysicsBody no SKSpriteNode da aranha
               size: spriteNode.size,                   // Usa o tamanho do sprite para definir o tamanho do corpo físico
               affectedByGravity: false,                // A aranha não sofre influência da gravidade (ela sobe/desce sozinha)
               allowsRotation: false,                   // Impede que a aranha gire ao colidir com outros objetos
               isDynamic: false,
               categoryBitMask: PhysicsCategory.spider, // Define que a aranha pertence à categoria "spider"
               
               contactTestBitMask: PhysicsCategory.player | PhysicsCategory.playerAttack,
               // Detecta contatos com o jogador ou com ataques do jogador. Isso é importante para disparar eventos como causar dano ou morrer.
               
               collisionBitMask: 0 // Não colide com nada
        )
        addComponent(physicsComponent)
        
        
        let stateMachineComponent = StateMachineComponent(states: [
            SpiderIdleState(entity: self),
            SpiderMoveState(entity: self),
            SpiderAttackState(entity: self),
            SpiderDeadState(entity: self)
        ])
        addComponent(stateMachineComponent)
        
        stateMachineComponent.stateMachine.enter(SpiderMoveState.self)
        
        let movementComponent = MovementComponent()
        addComponent(movementComponent)
        
        let animationComponent = AnimationComponent(node: spriteNode)
                let idleAnima = SKAction.repeatForever(.animate(with: .init(withFormat: "hat-man-idle-%@", range: 1...4), timePerFrame: 0.1))
        let walkAnima = SKAction.repeatForever(.animate(with: .init(withFormat: "hat-man-walk-%@", range: 1...6), timePerFrame: 0.1))
        let attAnima = SKAction.repeatForever(.animate(with: .init(withFormat: "woman-walk-%@", range: 1...6), timePerFrame: 0.1))
        let dedAnima = SKAction.repeatForever(.animate(with: .init(withFormat: "bearded-walk-%@", range: 1...6), timePerFrame: 0.1))
        
        
        
        animationComponent.addAnimation(named: "subindo", action: walkAnima)
        animationComponent.addAnimation(named: "descendo", action: walkAnima)
        animationComponent.addAnimation(named: "parado", action: idleAnima)
        animationComponent.addAnimation(named: "ataque", action: attAnima)
        animationComponent.addAnimation(named: "morte", action: dedAnima)
        
        addComponent(animationComponent)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpiderEntity {
    var spiderMoveState: SpiderMoveState? {
        return component(ofType: StateMachineComponent.self)?.stateMachine.currentState as? SpiderMoveState
    }
    
    func handleCollision(with otherNode: SKNode) {
        switch otherNode.name {
        case "player":
            stateMachineComponent?.stateMachine.enter(SpiderAttackState.self)
        case "playerAttack":
            stateMachineComponent?.stateMachine.enter(SpiderDeadState.self)
        default:
            break
        }
    }
}
