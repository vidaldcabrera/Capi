import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    let node: SKSpriteNode
    var animations: [String: SKAction] = [:]
    var currentAnimationKey: String?

    init(node: SKSpriteNode) {
        self.node = node
        super.init()
    }

    func addAnimation(named name: String, action: SKAction) {
        animations[name] = action
    }

    func runAnimation(named name: String) {
        guard currentAnimationKey != name else { return }
        guard let action = animations[name] else { return }

        node.removeAllActions()
        node.run(action)
        currentAnimationKey = name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
