import Foundation
import SpriteKit
import GameplayKit

class ButtonComponent: GKComponent {
    unowned let node: SKSpriteNode
    private let action: () -> Void
    private let label: SKLabelNode?

    /// Inicializa com o sprite, ação e texto opcional
    init(node: SKSpriteNode, title: String? = nil, action: @escaping () -> Void) {
        self.node = node
        self.action = action
        if let title = title {
            let labelNode = SKLabelNode(text: title)
            labelNode.fontName = "Helvetica"
            labelNode.fontSize = 20
            labelNode.fontColor = .white
            labelNode.position = CGPoint(x: 0, y: -labelNode.frame.height / 2)
            node.addChild(labelNode)
            self.label = labelNode
        } else {
            self.label = nil
        }
        super.init()
        node.isUserInteractionEnabled = true
    }

    /// Verifica toque e executa ação
    func didTouch() {
        action()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
