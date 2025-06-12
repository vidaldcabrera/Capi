import Foundation
import SpriteKit
import GameplayKit


class SpiderMoveState: GKState {
    unowned let entity: SpiderEntity
    var direction: CGFloat = 1.0
    
    init(entity: SpiderEntity) {
        self.entity = entity
    }

    override func didEnter(from previousState: GKState?) {
        // Começa o movimento vertical
        print("Spider subindo e descendo")
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let node = entity.component(ofType: RenderComponent.self)?.node else { return }
        // Lógica de mover verticalmente a aranha
        let maxY: CGFloat = 500 // topo da teia
        let minY: CGFloat = 100 // chão da teia

        node.position.y += direction * 100 * seconds

        if node.position.y >= maxY {
            node.position.y = maxY
            direction = -1 // começa a descer
        } else if node.position.y <= minY {
            node.position.y = minY
            direction = 1 // começa a subir
        }



    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SpiderAttackState.self || stateClass == SpiderDeadState.self
    }
}
