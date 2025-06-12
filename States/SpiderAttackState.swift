import Foundation
import SpriteKit
import GameplayKit

class SpiderAttackState: GKState {
    unowned let entity: SpiderEntity
    init(entity: SpiderEntity) {
        self.entity = entity
    }

    override func didEnter(from previousState: GKState?) {
        // Trigger de dano aqui
        print("Spider atacando")
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SpiderDeadState.self || stateClass == SpiderMoveState.self
    }
}
