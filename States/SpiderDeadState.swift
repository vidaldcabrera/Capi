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

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}
