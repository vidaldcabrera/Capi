import Foundation
import SpriteKit
import GameplayKit


class SpiderIdleState: GKState {
    unowned let entity: SpiderEntity
    init(entity: SpiderEntity) {
        self.entity = entity
    }

    override func didEnter(from previousState: GKState?) {
        // Coloque a animação idle ou esconde a aranha
        print("Spider entrou em IDLE")
    }

    override func update(deltaTime seconds: TimeInterval) {
        if let movement = entity.component(ofType: MovementComponent.self) {
            movement.spiderIdleMovement(deltaTime: seconds)
        }
    }

    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SpiderMoveState.self
    }
}
