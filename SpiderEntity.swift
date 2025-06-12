import Foundation
import SpriteKit
import GameplayKit

class SpiderEntity: GKEntity {
    init(texture: SKTexture, position: CGPoint) {
        super.init()
        
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.position = position
        spriteNode.name = "spider"
        
        let renderComponent = RenderComponent(node: spriteNode)

        
        addComponent(renderComponent)


        let stateMachineComponent = StateMachineComponent(states: [
            SpiderIdleState(entity: self),
            SpiderMoveState(entity: self),
            SpiderAttackState(entity: self),
            SpiderDeadState(entity: self)
        ])
        addComponent(stateMachineComponent)
        
        stateMachineComponent.stateMachine.enter(SpiderMoveState.self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
