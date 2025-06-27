//
//  ButtonComponent.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 17/06/25.
//

import SpriteKit
import GameplayKit

class ButtonComponent: GKComponent {
    private let sprite: SKSpriteNode
    private let label: String
    let action: () -> Void

    init(node: SKSpriteNode, label: String, action: @escaping () -> Void) {
        self.sprite = node
        self.action = action
        self.label = label
        super.init()
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
