import Foundation
import SpriteKit
import GameplayKit

class MosquitoAttackingState: GKState {

    unowned let mosquito: MosquitoEntity

    init(mosquito: MosquitoEntity) {
        self.mosquito = mosquito
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        // Para tudo antes de atacar
        mosquito.spriteNode.removeAllActions()

        // Carrega a animação de ataque (os frames devem estar na entidade)
        if !mosquito.attackFrames.isEmpty {
            let attackAnimation = SKAction.animate(with: mosquito.attackFrames, timePerFrame: 0.1)

            // Após a animação, volta para patrulha
            let returnToFly = SKAction.run { [weak self] in
                self?.mosquito.mosquitoStateMachine.enter(MosquitoFlyingState.self)
            }

            let sequence = SKAction.sequence([attackAnimation, returnToFly])
            mosquito.spriteNode.run(sequence, withKey: "AttackAnimation")
        } else {
            // Se não tiver frames de ataque, apenas volta pro FlyingState
            mosquito.mosquitoStateMachine.enter(MosquitoFlyingState.self)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == MosquitoFlyingState.self || stateClass == MosquitoDyingState.self
    }
}
