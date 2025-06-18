import Foundation
import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
    let spriteNode: SKSpriteNode
    
    init(position: CGPoint) {
        // Cria um quadrado azul simples como placeholder do player
        spriteNode = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 40))
        spriteNode.position = position
        spriteNode.name = "player"
        
        // Configura o physicsBody do player
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.isDynamic = true
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.player
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.mosquito
        spriteNode.physicsBody?.collisionBitMask = PhysicsCategory.chao // Só colide com o chão, por exemplo
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
