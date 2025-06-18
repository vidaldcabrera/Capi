import Foundation
import SpriteKit
import GameplayKit

class AttackingState: GKState {

    unowned let bat: BatEntity

    init(bat: BatEntity) {
        self.bat = bat
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        // Para tudo antes de atacar
        bat.spriteNode.removeAllActions()

        // Carrega a animação de ataque (os frames devem estar na entidade)
        if !bat.attackFrames.isEmpty {
            let attackAnimation = SKAction.animate(with: bat.attackFrames, timePerFrame: 0.1)

            // Após a animação, volta para patrulha
            let returnToFly = SKAction.run { [weak self] in
                self?.bat.batStateMachine.enter(FlyingState.self)
            }

            let sequence = SKAction.sequence([attackAnimation, returnToFly])
            bat.spriteNode.run(sequence, withKey: "AttackAnimation")
        } else {
            // Se não tiver frames de ataque, apenas volta pro FlyingState
            bat.batStateMachine.enter(FlyingState.self)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == FlyingState.self || stateClass == DyingState.self
    }
}
