//
//  ButtonNode.swift
//  Capi iOS
//
//  Created by Gabriella Tomoda on 12/06/25.
//

import Foundation
import SpriteKit


class ButtonNode: SKNode {
    var sprite: SKSpriteNode
    var label: SKLabelNode
    
    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has notbeen implemented")
    }
}
