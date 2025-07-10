import Foundation
import SpriteKit
import GameplayKit

class MosquitoEntity: GKEntity {
    
    var mosquitoStateMachine: GKStateMachine!
    var spriteNode: SKSpriteNode!
    
    // Arrays de frames por animação
    var flyFrames: [SKTexture] = []
    var attackFrames: [SKTexture] = []
    var deathFrames: [SKTexture] = []

    init(position: CGPoint) {
        super.init()
        
        // Carregar os frames de cada animação
        flyFrames = loadFrames(from: "MosquitoFlying", frameCount: 9)
        attackFrames = loadFrames(from: "MosquitoAttack", frameCount: 8)
        deathFrames = loadFrames(from: "MosquitoDeath", frameCount: 12)
        
        // Criar o sprite node com o primeiro frame da animação de voo
        spriteNode = SKSpriteNode(texture: flyFrames.first)
        spriteNode.position = position
        spriteNode.name = "mosquito"
        
        // Configuração da física
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.isDynamic = false
        spriteNode.physicsBody?.affectedByGravity = false
        
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.mosquito
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
        spriteNode.physicsBody?.collisionBitMask = PhysicsCategory.ground

        
        // Estados
        let fly = MosquitoFlyingState(mosquito: self, leftLimit: position.x - 50, rightLimit: position.x + 50)
        let attack = MosquitoAttackingState(mosquito: self)
        let death = MosquitoDyingState(mosquito: self)
        
        mosquitoStateMachine = GKStateMachine(states: [fly, attack, death])
        mosquitoStateMachine.enter(MosquitoFlyingState.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Função genérica pra cortar spritesheets horizontais
    private func loadFrames(from imageName: String, frameCount: Int) -> [SKTexture] {
        let texture = SKTexture(imageNamed: imageName)
        let frameWidth = 1.0 / CGFloat(frameCount)
        var frames: [SKTexture] = []

        for i in 0..<frameCount {
            let frameRect = CGRect(x: CGFloat(i) * frameWidth, y: 0, width: frameWidth, height: 1.0)
            let frameTexture = SKTexture(rect: frameRect, in: texture)
            frames.append(frameTexture)
        }

        return frames
    }
}
