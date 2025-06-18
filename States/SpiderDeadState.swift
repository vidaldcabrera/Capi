import Foundation
import SpriteKit
import GameplayKit


class SpiderDeadState: GKState {
    unowned let entity: SpiderEntity
    init(entity: SpiderEntity) {
        self.entity = entity
    }

    override func didEnter(from previousState: GKState?) {
        if let node = entity.component(ofType: RenderComponent.self)?.node {
            node.removeFromParent()
        }
        print("Spider morreu")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let movement = entity.component(ofType: MovementComponent.self) {
            movement.spiderDeadMovement(deltaTime: seconds)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}
