import Foundation
import SpriteKit
import GameplayKit

class ButtonEntity: GKEntity {
    let spriteNode: SKSpriteNode
    private let component: ButtonComponent

    init(position: CGPoint, size: CGSize, title: String? = nil, action: @escaping () -> Void) {
        // Configuração do sprite do botão
        spriteNode = SKSpriteNode(color: .gray, size: size)
        spriteNode.position = position
        spriteNode.name = "button"

        // Componente de botão com ação
        component = ButtonComponent(node: spriteNode, title: title, action: action)

        super.init()
        addComponent(component)
        addComponent(GKSKNodeComponent(node: spriteNode))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
