import Foundation
import SpriteKit
import GameplayKit

class MosquitoFlyingState: GKState{
    
    unowned let mosquito: MosquitoEntity
        let leftLimit: CGFloat
        let rightLimit: CGFloat
        var goingRight = true
        let speed: CGFloat = 80

        init(mosquito: MosquitoEntity, leftLimit: CGFloat, rightLimit: CGFloat) {
            self.mosquito = mosquito
            self.leftLimit = leftLimit
            self.rightLimit = rightLimit
            super.init()
        }
    override func didEnter(from previousState: GKState?) {
        // Para garantir que não empilhe ações
        mosquito.spriteNode.removeAllActions()

        // Animação de voo
        let flyAnimation = SKAction.animate(with: mosquito.flyFrames, timePerFrame: 0.1)
        let repeatFly = SKAction.repeatForever(flyAnimation)
        mosquito.spriteNode.run(repeatFly, withKey: "FlyAnimation")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
            let direction: CGFloat = goingRight ? 1 : -1
        mosquito.spriteNode.position.x += direction * speed * CGFloat(seconds)
        
        mosquito.spriteNode.xScale = goingRight ? -1.0 : 1.0

            
        if mosquito.spriteNode.position.x >= rightLimit {
                goingRight = false
        } else if mosquito.spriteNode.position.x <= leftLimit {
                goingRight = true
            }
        }

        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == MosquitoAttackingState.self || stateClass == MosquitoDyingState.self
        }
    }
