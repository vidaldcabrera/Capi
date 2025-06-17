import Foundation
import GameplayKit
import SpriteKit

class AttackingState: GKState {
    
    unowned let mosquito: MosquitoEntity
    
    init(mosquito: MosquitoEntity) {
        self.mosquito = mosquito
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Remove qualquer animação antiga
        mosquito.spriteNode.removeAllActions()
        
        // Cria a animação de ataque usando os frames
        let attackAnimation = SKAction.animate(with: mosquito.attackFrames, timePerFrame: 0.1)
        
        // Após o ataque, volta pro estado de voo
        let returnToFlyState = SKAction.run { [weak self] in
            self?.mosquito.mosquitoStateMachine.enter(FlyingState.self)
        }
        
        let sequence = SKAction.sequence([attackAnimation, returnToFlyState])
        mosquito.spriteNode.run(sequence, withKey: "Animation")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == FlyingState.self || stateClass == DyingState.self
    }
}
