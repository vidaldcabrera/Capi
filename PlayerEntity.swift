import Foundation
import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
    var moveComponent: MovementComponent? {
        return component(ofType: MovementComponent.self)
    }
    
    override init() {
        super.init()
        let node = SKSpriteNode(imageNamed: "idle1.png")
        node.anchorPoint = .init(x: 0.5, y: 0)
        node.setScale(4)
        self.addComponent(GKSKNodeComponent(node: node))
        
        let animationComp = AnimationComponent(
            idleAction: .repeatForever(.animate(with: .init(withFormat: "idle%@.png", range: 1...7), timePerFrame: 0.1)),
            runAction: .repeatForever(.animate(with: .init(withFormat: "walk%@.png", range: 1...7), timePerFrame: 0.1)))
        self.addComponent(animationComp)
        
        let moveComponent = MovementComponent(speed: 5)
        self.addComponent(moveComponent)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not bee implemented")
    }
}
