//
//  ButtonEntity.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 11/06/25.
//

import SpriteKit
import GameplayKit

class ButtonEntity: GKEntity {
    init(imageNamed: String, position: CGPoint, name: String, title: String, action: @escaping () -> Void) {
        super.init()

        let spriteNode = SKSpriteNode(imageNamed: imageNamed)
        spriteNode.name = name
        spriteNode.position = position
        spriteNode.zPosition = 15

        // Adiciona texto centralizado sobre o botão
        let label = FontFactory.makeButton(title, at: .zero) // posição relativa ao centro do sprite
        label.zPosition = spriteNode.zPosition + 1
        spriteNode.addChild(label)
        
        let nodeComponent = GKSKNodeComponent(node: spriteNode)
        let buttonComponent = ButtonComponent(node: spriteNode, title: title, label: title, action: action)

        addComponent(nodeComponent)
        addComponent(buttonComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
