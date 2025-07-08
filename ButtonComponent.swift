import Foundation
import SpriteKit
import GameplayKit

class ButtonComponent: GKComponent {
    private let sprite: SKSpriteNode
    let title: String
    let action: () -> Void
    let label: String
    
    init(node: SKSpriteNode, title: String, label: String, action: @escaping () -> Void) {
        self.sprite = node
        self.title = title
        self.action = action
        self.label = label
        super.init()
        node.isUserInteractionEnabled = true
    }
    

    /// Torna a função pública
    public func handleTouch(location: CGPoint) {
        if sprite.contains(location) {
            VoiceOverManager.shared.speak(label)
            sprite.run(SKAction.sequence([
                SKAction.scale(to: 0.95, duration: 0.05),
                SKAction.scale(to: 1.0, duration: 0.05)
            ]))
            action()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
