import SpriteKit
import GameplayKit

class DyingState: GKState {
    unowned let bat: BatEntity

    init(bat: BatEntity) {
        self.bat = bat
    }

    override func didEnter(from previousState: GKState?) {
        bat.spriteNode.removeAllActions()

        let deathAnimation = SKAction.animate(with: bat.deathFrames, timePerFrame: 0.1)
        let removeNode = SKAction.removeFromParent()

        let sequence = SKAction.sequence([deathAnimation, removeNode])

        bat.spriteNode.run(sequence, withKey: "Animation")
    }
}
