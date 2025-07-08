import SpriteKit

class FontFactory {
    
    // Fonte adicionada no projeto (VT323-Regular)
    //static let fontName = "VT323-Regular"
    static let fontName = "PressStart2P-Regular"
    
    // Título grande (ex: título de tela)
    static func makeTitle(_ text: String, at position: CGPoint) -> SKNode {
        return createLabel(text: text, fontSize: 24, color: .white, position: position)
    }
    
    // Botão (ex: botão "Iniciar", "Sair", etc.)
    static func makeButton(_ text: String, at position: CGPoint) -> SKNode {
        return createLabel(text: text, fontSize: 10, color: .white, position: position)
    } //ok
    
    // Subtítulo (ex: instruções ou nomes de menu)
    static func makeSubtitle(_ text: String, at position: CGPoint) -> SKNode {
        return createLabel(text: text, fontSize: 14, color: .white, position: position)
    }
    
    // Label base compartilhada
    private static func createLabel(text: String, fontSize: CGFloat, color: SKColor, position: CGPoint) -> SKNode {
        let label = SKLabelNode(text: text)
        label.fontName = fontName
        label.fontSize = fontSize
        label.fontColor = color
        label.position = .zero
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.yScale = 2.0
        label.xScale = 1.0
        label.zPosition = 1

        let shadow = SKLabelNode(text: text)
        shadow.fontName = fontName
        shadow.fontSize = fontSize
        shadow.fontColor = .black
        shadow.position = CGPoint(x: 3, y: -2)
        shadow.horizontalAlignmentMode = .center
        shadow.verticalAlignmentMode = .center
        shadow.yScale = 2.0
        shadow.xScale = 1.0
        shadow.zPosition = 0

        let container = SKNode()
        container.position = position
        container.addChild(shadow)
        container.addChild(label)
        
        return container
    }

}
