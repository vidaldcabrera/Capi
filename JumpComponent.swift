import Foundation
import SpriteKit
import GameplayKit

class JumpComponent: GKComponent {
    unowned let node: SKSpriteNode
    private let jumpFrames: [SKTexture]
    private let impulse: CGVector

    /// Inicializa com o nó, frames de animação e vetor de impulso
    init(node: SKSpriteNode, frames: [SKTexture], impulse: CGVector) {
        self.node = node
        self.jumpFrames = frames
        self.impulse = impulse
        super.init()
    }

    /// Executa o pulo: animação e física
    func jump() {
        guard node.physicsBody?.velocity.dy == 0 else { return } // Não pula no ar

        // Aplica impulso
        node.physicsBody?.applyImpulse(impulse)

        // Animação de pulo
        let jumpAnimation = SKAction.animate(with: jumpFrames, timePerFrame: 0.08)
        node.run(jumpAnimation, withKey: "jump")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
