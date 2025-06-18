import Foundation
import SpriteKit
import GameplayKit

class SpiderMoveState: GKState {
    unowned let entity: SpiderEntity
    
    init(entity: SpiderEntity) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Spider subindo e descendo")
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if let movement = entity.component(ofType: MovementComponent.self) {
            movement.spiderVerticalMovement()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SpiderAttackState.self || stateClass == SpiderDeadState.self
    }
}
