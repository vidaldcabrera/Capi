//
//  ButtonEntity.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 11/06/25.
//

import SpriteKit
import GameplayKit

class ButtonEntity: GKEntity {
    init(imageNamed: String, position: CGPoint, name: String, action: @escaping () -> Void, label: String) {
        super.init()

        let spriteNode = SKSpriteNode(imageNamed: imageNamed)
        spriteNode.name = name
        spriteNode.position = position
        spriteNode.zPosition = 10

        let nodeComponent = GKSKNodeComponent(node: spriteNode)
        let buttonComponent = ButtonComponent(node: spriteNode, label: label, action: action)

        addComponent(nodeComponent)
        addComponent(buttonComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
