import SpriteKit
import GameplayKit



class MosquitoDyingState: GKState {
    unowned let mosquito: MosquitoEntity

    init(mosquito: MosquitoEntity) {
        self.mosquito = mosquito
    }

    override func didEnter(from previousState: GKState?) {
        mosquito.spriteNode.removeAllActions()

        let deathAnimation = SKAction.animate(with: mosquito.deathFrames, timePerFrame: 0.1)
        let removeNode = SKAction.removeFromParent()

        let sequence = SKAction.sequence([deathAnimation, removeNode])

        mosquito.spriteNode.run(sequence, withKey: "Animation")
    }
}

