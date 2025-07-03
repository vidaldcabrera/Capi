import SpriteKit

/// Nó interativo para botões na UI do jogo
class ButtonNode: SKSpriteNode {
    private let action: () -> Void

    /// Inicializa com cor, tamanho, texto opcional e ação
    init(color: SKColor = .gray,
         size: CGSize,
         title: String? = nil,
         action: @escaping () -> Void) {
        self.action = action
        super.init(texture: nil, color: color, size: size)
        isUserInteractionEnabled = true
        name = "buttonNode"

        // Setup de rótulo
        if let title = title {
            let label = SKLabelNode(text: title)
            label.fontName = "Helvetica-Bold"
            label.fontSize = 18
            label.fontColor = .white
            label.verticalAlignmentMode = .center
            addChild(label)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Detecta toque e executa ação
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        action()
    }
}
