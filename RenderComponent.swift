import SpriteKit
import GameplayKit

class RenderComponent: GKComponent {
    unowned let node: SKSpriteNode

    /// Inicializa com o sprite node a ser renderizado
    init(node: SKSpriteNode) {
        self.node = node
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
