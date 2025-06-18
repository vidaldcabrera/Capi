import Foundation
import SpriteKit
import GameplayKit

class SpiderAttackState: GKState {
    unowned let entity: SpiderEntity
    private var elapsedTime: TimeInterval = 0
    
    init(entity: SpiderEntity) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        elapsedTime = 0
        // Trigger de dano aqui
        print("Spider atacando")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // print(seconds)
        elapsedTime += 1
        if let movement = entity.component(ofType: MovementComponent.self) {
            movement.spiderAttackMovement()
        }
        if elapsedTime >= 15 { // Aqui vai depender do nosso sprite
            elapsedTime = 0
            // volta para o estado de movimento
            entity.component(ofType: StateMachineComponent.self)?
                .stateMachine.enter(SpiderMoveState.self)
            
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SpiderDeadState.self || stateClass == SpiderMoveState.self
    }
}
